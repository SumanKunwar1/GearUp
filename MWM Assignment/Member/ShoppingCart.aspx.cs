using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWM_Assignment
{
    public partial class ShoppingCart : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] == null)
            {
                Response.Redirect("../Login.aspx");
            }

            if (!IsPostBack) loadCart();


        }

        private void loadCart()
        {
            DataTable dt = getCart();

            dlCart.DataSource = dt;
            dlCart.DataBind();

            int itemCount = dt.Rows.Count;
            lblItems.Text = "Total ("+ itemCount.ToString() + (itemCount == 1 ? " item": " items") + "): ";

            double total = getGrandTotal();
            lblTotal.Text = string.Format("{0:C}", total);
        }

        private DataTable getCart()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            int uid = int.Parse(Session["uid"].ToString());

            string query = "select sc.*, p.*, (sc.qty * p.price) as 'subtotal' from tblShoppingCart sc inner join tblProducts p on sc.pid = p.pid where sc.uid = @uid and status='Pending'";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", uid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();

            return dt;
        }

        protected void dlCart_ItemCommand(object source, DataListCommandEventArgs e)
        {
            string pid = "";
            pid = e.CommandArgument.ToString();

            switch (e.CommandName)
            {
                case "update":
                    TextBox txtQty = e.Item.FindControl("txtQty") as TextBox;
                    int qty = int.Parse(txtQty.Text);

                    updateQuantity(int.Parse(pid), qty);
                    loadCart();
                    break;
                case "delete":

                    deleteFromCart(int.Parse(pid));
                    loadCart();
                    break;
            }
        }
        private void updateQuantity(int pid, int quantity)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "update tblShoppingCart set qty = @qty where uid = @uid and pid = @pid and status='Pending'";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@qty", quantity);
            comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
            comm.Parameters.AddWithValue("@pid", pid);

            int result = comm.ExecuteNonQuery();
            if (result > 0)
            {
                setStatus(true, "Updated!");
            }
            else
            {
                setStatus(false, "Something went wrong! Please try again.");
            }
            conn.Close();
        }

        private void deleteFromCart(int pid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "delete from tblShoppingCart where uid = @uid and pid = @pid and status='Pending'";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
            comm.Parameters.AddWithValue("@pid", pid);

            int result = comm.ExecuteNonQuery();
            if (result > 0)
            {
                setStatus(true, "Deleted!");
            }
            else
            {
                setStatus(false, "Something went wrong! Please try again.");
            }
            conn.Close();
        }

        private double getGrandTotal()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT SUM(sc.qty * p.price) AS grandsubtotal FROM tblShoppingCart sc INNER JOIN tblProducts p ON sc.pid = p.pid WHERE sc.uid = @uid and status = 'Pending'";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));

            SqlDataReader reader = comm.ExecuteReader();

            double total = 0;
            if (reader.Read())
            {
                if (double.TryParse(reader["grandsubtotal"].ToString(), out total))
                {
                    conn.Close();
                    return total;
                }
            }

            conn.Close();
            return 0;
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            DataTable dt = getCart();

            if (dt.Rows.Count != 0)
            {
                Response.Redirect("Checkout.aspx");
            }
            else
            {
                setStatus(false, "No items found!");
            }

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
    }
}