using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace MWM_Assignment.Admin
{
    public partial class ManageOrders : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        private readonly Dictionary<int, string> statusDictionary = new Dictionary<int, string>()
        {
           { 1, "Paid" },
           { 2, "Shipped" },
           { 3, "Delivered" },
           { 4, "Cancelled" },
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            MasterPage masterPage = (MasterPage)this.Master;
            HtmlAnchor masterAnchor = (HtmlAnchor)masterPage.FindControl("hOrders");
            masterAnchor.Attributes["class"] = "nav_link active";

            if (!IsPostBack) populateTable();


            int orderTab = 1;
            if (Request.QueryString["orderTab"] != null)
            {
                int.TryParse(Request.QueryString["orderTab"].ToString(), out orderTab);
            }
            switch (orderTab)
            {
                case 2:
                    hReceived.Attributes["class"] = "nav-link active";
                    break;
                case 3:
                    hCompleted.Attributes["class"] = "nav-link active";
                    break;
                case 4:
                    hCancelled.Attributes["class"] = "nav-link active";
                    break;
                default:
                    hPaid.Attributes["class"] = "nav-link active";
                    break;
            }
        }

        protected void lvOrder_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            (lvOrder.FindControl("dpOrder") as DataPager).SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            this.populateTable();
        }

        private void populateTable()
        {
            int orderTab = 1;

            if (Request.QueryString["orderTab"] != null)
            {
                int.TryParse(Request.QueryString["orderTab"].ToString(), out orderTab);
            }

            DataTable dt = getOrdersForTable(orderTab);
            lvOrder.DataSource = dt;
            lvOrder.DataBind();
        }

        private DataTable getOrdersForTable(int statusCd)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string status = statusDictionary[statusCd];

            string query = "select distinct oid, name, address, contact, status from tblOrders where status like @status";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@status", "%" + status + "%");

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            return dt;
        }

        protected double getSubtotal(string oid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select sum(subtotal + tax) as 'subtotal' from tblOrders where oid = @oid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@oid", oid);

            SqlDataReader reader = comm.ExecuteReader();
            double total = 0;
            if (reader.Read())
            {
                double.TryParse(reader["subtotal"].ToString().Trim(), out total);
                reader.Close();
                conn.Close();
            }
            return total;
        }

        protected DataTable getProductFromOrders(string oid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select p.name, p.image, p.price from tblProducts p inner join tblOrders o on p.pid = o.pid where o.oid = @oid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@oid", oid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            return dt;
        }

        protected void btnShip_Click(object sender, EventArgs e)
        {
            string oid = hfOid.Value.ToString();

            if (oid == string.Empty) return;

            updateOrderStatus(oid, "Shipped");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            string oid = hfOid.Value.ToString();
            if (oid == string.Empty) return;

            updateOrderStatus(oid, "Cancelled");

        }

        private void updateOrderStatus(string oid, string status)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "UPDATE tblOrders SET status = @status, dtUpdated = GETDATE() WHERE oid=@oid";
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@status", status);
            comm.Parameters.AddWithValue("@oid", oid);

            comm.ExecuteNonQuery();
            conn.Close();

            populateTable();
        }
    }
}