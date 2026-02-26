using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.EnterpriseServices;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace MWM_Assignment
{
    public partial class Orders : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        private readonly Dictionary<int, string> statusDictionary = new Dictionary<int, string>()
        {
           { 1, "Paid" },
           { 2, "Shipped" },
           { 3, "Delivered" },
           { 4, "Cancelled" }
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] == null)
            {
                Response.Redirect("~/");
                return;
            }

            if (!IsPostBack) populateData();
        }

        private void populateData()
        {
            DataTable dtPaid = getOrdersTable(1);
            dlPaid.DataSource = dtPaid;
            dlPaid.DataBind();

            DataTable dtShipped = getOrdersTable(2);
            dlShipped.DataSource = dtShipped;
            dlShipped.DataBind();

            DataTable dtDelivered = getOrdersTable(3);
            dlDelivered.DataSource = dtDelivered;
            dlDelivered.DataBind();

            DataTable dtCancelled = getOrdersTable(4);
            dlCancelled.DataSource = dtCancelled;
            dlCancelled.DataBind();
        }

        private DataTable getOrdersTable(int statusCd)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string status = statusDictionary[statusCd];

            string query = "select o.oid,sum(o.subTotal + o.tax) as 'subtotal',min(o.pid) as 'pid', (select qty from tblOrders o2 where o2.oid = min(o.oid) and o2.pid = min(o.pid)) as 'qty', (select price from tblOrders o2 where o2.oid = min(o.oid) and o2.pid = min(o.pid)) as 'price', (select dtAdded from tblOrders o2 where o2.oid = min(o.oid) and o2.pid = min(o.pid)) as 'dtAdded', (select status from tblOrders o2 where o2.oid = min(o.oid) and o2.pid = min(o.pid)) as 'status' ,(select name from tblProducts where pid = min(o.pid)) as 'name',(select image from tblProducts where pid = min(o.pid)) as 'image',count(*) as 'items' FROM tblOrders o where status like @status AND uid = @uid GROUP BY o.oid order by min(o.status) asc, min(o.dtAdded) desc;";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@status", "%" + status + "%");
            comm.Parameters.AddWithValue("@uid", Session["uid"].ToString());

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            return dt;
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

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            string oid = hfOid.Value.ToString().Trim();

            updateOrderStatus(oid, "Cancelled");
        }

        protected void btnReceived_Click(object sender, EventArgs e)
        {
            string oid = hfOid.Value.ToString().Trim();

            updateOrderStatus(oid, "Delivered");
        }

        protected void btnRate_Click(object sender, EventArgs e)
        {
            string oid = hfOid.Value.ToString().Trim();

            if (oid != string.Empty)
            {
                if (insertReview(oid))
                {
                    updateOrderStatus(oid, "Rated and Delivered");
                }
            }

        }

        protected void btnBuy_Click(object sender, EventArgs e)
        {
            Response.Write("Add order to cart");
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

            populateData();
        }

        private bool insertReview(string oid)
        {
            DataTable dtOrder = getOrderData(oid);
            if (dtOrder.Rows.Count == 0)
            {
                throw new Exception();
            }


            if (!int.TryParse(hfRating.Value.ToString().Trim(), out int rating))
            {
                setStatus(false, "An error occurred, try again later");
                return false;
            }

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    string query = "INSERT INTO tblReview (pid, oid, uid, rating, description, dtAdded) VALUES " +
                        "(@pid, @oid, @uid, @rating, @description, GETDATE())";

                    foreach (DataRow row in dtOrder.Rows)
                    {
                        // SQL Command
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@pid", row["pid"]);
                        comm.Parameters.AddWithValue("@oid", oid);
                        comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
                        comm.Parameters.AddWithValue("@rating", rating);
                        comm.Parameters.AddWithValue("@description", txtReviewDesc.Text.ToString().Trim());

                        int result = comm.ExecuteNonQuery();
                    }

                    transaction.Commit();
                    setStatus(true, "Submitted successfully! Thanks for your review.");
                    populateData();
                    conn.Close();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    setStatus(false, "Submit failed! Please try again!");
                    populateData();
                    conn.Close();
                    return false;
                }
            }
        }

        private DataTable getOrderData(string oid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select * from tblOrders where oid = @oid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@oid", oid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            return dt;
        }

        protected bool checkReviewExist(string oid)
        {
            DataTable dtOrder = getOrderData(oid);

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblReview WHERE uid = @uid AND oid=@oid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", int.Parse(Session["uid"].ToString()));
            comm.Parameters.AddWithValue("@oid", oid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();

            if (dt.Rows.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
