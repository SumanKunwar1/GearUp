using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWM_Assignment
{
    public partial class ProductDetails : System.Web.UI.Page
    {
        private string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["pid"] != null)
            {
                Session["pid"] = Request.QueryString["pid"];
            }

            if (Session["pid"] != null)
            {
                int pid = int.Parse(Session["pid"].ToString());
                loadProduct(pid);
                loadReviews(pid);
            }
            else
            {
                Response.Redirect("ProductCatalog.aspx");
            }

            if (!IsPostBack) divStatus.Visible = false;
        }
        private void loadProduct(int pid)
        {
            // Open Connection

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select * from tblProducts where pid = @pid";

            // SQL Command

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@pid", pid);

            SqlDataReader reader = comm.ExecuteReader();
            if (reader.Read())
            {
                lblName.Text = reader["name"].ToString();
                lblDescription.Text = HttpUtility.HtmlDecode(reader["description"].ToString());
                lblPrice.Text = string.Format("{0:C}", reader["price"]);
                img_Image.ImageUrl = reader["image"].ToString();
            }

            reader.Close();
            conn.Close();
        }

        private void loadReviews(int pid)
        {
            DataTable dt = getReviews(pid);
            dlReview.DataSource = dt;
            dlReview.DataBind();

            double avgRating = getAverageRating(pid.ToString());
            lblAvgRating.Text = Math.Round(avgRating, 2).ToString();
        }

        private DataTable getReviews(int pid)
        {
            // Open Connection

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select r.*, c.name as 'custName', c.profilePicture as 'image' from tblReview r inner join tblCustomers c on r.uid = c.id where r.pid = @pid order by r.dtAdded desc";

            // SQL Command

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@pid", pid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);
            conn.Close();
            return dt;
        }

        protected double getAverageRating(string pid)
        {
            int.TryParse(pid, out int pidInt);

            DataTable dt = getReviews(pidInt);

            double averageRating = 0;

            foreach (DataRow row in dt.Rows)
            {
                int.TryParse(row["rating"].ToString(), out int rating);
                averageRating += rating;
            }

            if (dt.Rows.Count > 0) averageRating /= dt.Rows.Count;

            return averageRating;
        }

        protected void btnAddCart_Click(object sender, EventArgs e)
        {
            int quantity = 0;

            if (Session["uid"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (txt_Quantity.Text == string.Empty)
            {
                setStatus(false, "Quantity cannot be empty!");
                return;
            }

            if (int.TryParse(txt_Quantity.Text, out quantity) && quantity < 1)
            {
                string message = "Quantity cannot be less than 1!";
                setStatus(false, message);
                return;
            }

            if (checkCartExists())
            {
                updateCart();
            }
            else
            {
                insertCart();
            }
        }

        private void insertCart()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "INSERT INTO tblShoppingCart(uid, pid, qty, dtAdded, status) VALUES (@uid, @pid, @qty, @dtAdded, @status)";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
            comm.Parameters.AddWithValue("@pid", int.Parse(Session["pid"].ToString()));
            comm.Parameters.AddWithValue("@qty", int.Parse(txt_Quantity.Text));
            comm.Parameters.AddWithValue("@dtAdded", DateTime.Now);
            comm.Parameters.AddWithValue("@status", "Pending"); // 0 when delete

            int result = comm.ExecuteNonQuery();
            if (result > 0)
            {
                setStatus(true, "Added to Cart!");
            }
            else
            {
                setStatus(false, "Something went wrong. Please try again.");
            }

            conn.Close();
        }

        private bool checkCartExists()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select * from tblShoppingCart where uid = @uid and pid = @pid and status='Pending'";

            int uid = int.Parse(Session["uid"].ToString());
            int pid = int.Parse(Session["pid"].ToString());

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", uid);
            comm.Parameters.AddWithValue("@pid", pid);

            SqlDataReader sqlDataReader = comm.ExecuteReader();
            if (sqlDataReader.HasRows)
            {
                conn.Close();
                return true;
            }
            else
            {
                conn.Close();
                return false;
            }
        }

        private void updateCart()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select * from tblShoppingCart where uid = @uid and pid = @pid and status='Pending'";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
            comm.Parameters.AddWithValue("@pid", int.Parse(Session["pid"].ToString()));

            SqlDataReader reader = comm.ExecuteReader();
            if (reader.Read())
            {
                int quantity = int.Parse(reader["qty"].ToString());
                quantity += int.Parse(txt_Quantity.Text);

                reader.Close();

                string query2 = "update tblShoppingCart set qty = @qty where uid = @uid and pid = @pid and status='Pending'";

                // SQL Command
                SqlCommand comm2 = new SqlCommand(query2, conn);
                comm2.Parameters.AddWithValue("@qty", quantity);
                comm2.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
                comm2.Parameters.AddWithValue("@pid", int.Parse(Session["pid"].ToString()));

                int result = comm2.ExecuteNonQuery();
                if (result > 0)
                {
                    setStatus(true, "Added to Cart!");
                }
                else
                {
                    setStatus(false, "Something went wrong. Please try again.");
                }
            }

            conn.Close();
        }

        private void setStatus(bool status, string message)
        {
            if (status)
            {
                lblStatusIcon.CssClass = "bi-check-circle";
                statusBg.Attributes["class"] = "text-center text-md-start py-2 px-3 px-xl-5 align-items-center text-white bg-success";
            }
            else
            {
                lblStatusIcon.CssClass = "bi-x-circle";
                statusBg.Attributes["class"] = "text-center text-md-start py-2 px-3 px-xl-5 align-items-center text-white bg-danger";
            }

            lblStatus.Text = message;

            divStatus.Visible = true;
        }

        protected void btnGoCart_Click(object sender, EventArgs e)
        {
            int quantity = 0;

            if (Session["uid"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (int.TryParse(txt_Quantity.Text, out quantity) && quantity < 1)
            {
                string message = "Quantity cannot be less than 1!";
                setStatus(false, message);
                return;
            }

            if (checkCartExists())
            {
                updateCart();
            }
            else
            {
                insertCart();
            }

            Response.Redirect("Member/ShoppingCart.aspx");
        }
    }
}