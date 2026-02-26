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
    public partial class Checkout : System.Web.UI.Page
    {
        private string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

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

            double total = getGrandTotal();
            lblTotal.Text = string.Format("{0:C}", total);
            lblTax.Text = string.Format("{0:C}", total * 0.1);
            lblSubtotal.Text = string.Format("{0:C}", total * 0.1 + total);
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

        protected void btnPay_Click(object sender, EventArgs e)
        {
            DataTable dt = getCart();

            Session["CartData"] = dt;

            Response.Redirect("Payment.aspx");
        }
    }
}