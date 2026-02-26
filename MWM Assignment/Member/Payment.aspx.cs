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
    public partial class Payment : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] == null)
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (Session["CartData"] == null)
            {
                Response.Redirect("ShoppingCart.aspx");
                return;
            }

            if (!IsPostBack) makePayment();
        }

        private void makePayment()
        {
            string orderRef = insertOrder();
            if (orderRef == string.Empty)
            {
                // Payment Failed
                return;
            }

            DataTable orderData = getOrder(orderRef);
            if (orderData.Rows.Count == 0)
            {
                return;
            }

            lblOrderRef.Text = orderRef;
            lblTimestamp.Text = orderData.Rows[0]["dtAdded"].ToString();
            lblTotal.Text = string.Format("{0:C}", orderData.Rows[0]["grandsubtotal"]);
            updateCart();

        }

        private string insertOrder()
        {
            DataTable cartData = (DataTable)Session["CartData"];

            DataTable userData = getUser();
            if (userData.Rows.Count == 0)
            {
                throw new Exception();
            }

            Guid uuid = Guid.NewGuid();

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    string query = "INSERT INTO tblOrders (oid, pid, uid, qty, price, subtotal, tax, name, address, contact, dtAdded, dtUpdated, status) VALUES " +
                        "(@oid, @pid, @uid, @qty, @price, @subTotal, @tax, @name, @address, @contact , GETDATE(), GETDATE(), @status)";

                    foreach (DataRow row in cartData.Rows)
                    {
                        double subtotal = double.Parse(row["subtotal"].ToString());
                        double tax = subtotal * 0.10;

                        // SQL Command
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@oid", uuid.ToString());
                        comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
                        comm.Parameters.AddWithValue("@pid", row["pid"]);
                        comm.Parameters.AddWithValue("@qty", row["qty"]);
                        comm.Parameters.AddWithValue("@price", row["price"]);
                        comm.Parameters.AddWithValue("@subtotal", row["subtotal"]);
                        comm.Parameters.AddWithValue("@tax", tax);
                        comm.Parameters.AddWithValue("@name", userData.Rows[0]["name"]);
                        comm.Parameters.AddWithValue("@address", userData.Rows[0]["address"]);
                        comm.Parameters.AddWithValue("@contact", userData.Rows[0]["contact"]);
                        comm.Parameters.AddWithValue("@status", "Paid");

                        int result = comm.ExecuteNonQuery();
                    }

                    transaction.Commit();
                    conn.Close();
                    return uuid.ToString();
                }
                catch
                {
                    transaction.Rollback();
                    conn.Close();
                    return string.Empty;
                }
            }
        }

        private void updateCart()
        {

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "update tblShoppingCart set status = @status where uid = @uid and status='Pending'";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@status", "Completed");
            comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));

            comm.ExecuteNonQuery();

            conn.Close();

            Session["CartData"] = null;
        }

        private DataTable getOrder(string orderRef)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            int uid = int.Parse(Session["uid"].ToString());

            string query = "select *, (select sum(subtotal + tax) from tblOrders where oid = @oid) as 'grandsubtotal' from tblOrders where oid = @oid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@oid", orderRef);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();

            return dt;
        }

        private DataTable getUser()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            int uid = int.Parse(Session["uid"].ToString());

            string query = "select * from tblCustomers where id = @uid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", Session["uid"].ToString());

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();

            return dt;
        }
    }
}