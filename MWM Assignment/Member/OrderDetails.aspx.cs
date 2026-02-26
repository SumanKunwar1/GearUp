using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.EnterpriseServices;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWM_Assignment
{
    public partial class OrderDetails : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] == null)
            {
                Response.Redirect("../Login.aspx");
            }
            
            string oid = Request.QueryString["oid"];
            if (oid != null)
            {
                DataTable dtProduct = getOrderDetails(oid);
                if (dtProduct.Rows.Count > 0)
                {
                    lblStatus.Text = dtProduct.Rows[0]["status"].ToString();
                    lblDtUpdated.Text = dtProduct.Rows[0]["dtUpdated"].ToString();
                    lblName.Text = dtProduct.Rows[0]["username"].ToString();
                    lblContact.Text = dtProduct.Rows[0]["contact"].ToString();
                    lblAddress.Text = dtProduct.Rows[0]["address"].ToString();
                }
                dlOrders.DataSource = dtProduct;
                dlOrders.DataBind();

                DataTable dtTotal = getGrandTotal(oid);
                if (dtTotal.Rows.Count == 1)
                {
                    lblTotal.Text = string.Format("{0:C}", double.Parse(dtTotal.Rows[0]["basetotal"].ToString()));
                    lblTax.Text = string.Format("{0:C}", double.Parse(dtTotal.Rows[0]["taxtotal"].ToString()));
                    lblSubtotal.Text = string.Format("{0:C}", double.Parse(dtTotal.Rows[0]["subtotal"].ToString()));
                }
            }
        }

        private DataTable getOrderDetails(string oid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select o.oid, (o.subTotal + o.tax) as 'subtotal', o.status, o.qty, o.dtUpdated, o.name as 'username', o.address, o.contact, p.pid, p.image, p.name, p.price from tblOrders o inner join tblProducts p on o.pid = p.pid where oid = @oid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@oid", oid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();

            return dt;

        }

        private DataTable getGrandTotal(string oid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select sum(subtotal) as 'basetotal', sum(tax) as 'taxtotal', sum(subtotal + tax) as 'subtotal' from tblOrders where oid = @oid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@oid", oid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();

            return dt;
        }

    }
}