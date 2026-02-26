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
    public partial class ManageFeedback : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            MasterPage masterPage = (MasterPage)this.Master;
            HtmlAnchor masterAnchor = (HtmlAnchor)masterPage.FindControl("hFeedbacks");
            masterAnchor.Attributes["class"] = "nav_link active";

            if (!IsPostBack) populateTable();
        }

        private void populateTable()
        {
            DataTable dt = getFeedback();
            lvFeedback.DataSource = dt;
            lvFeedback.DataBind();
        }

        private DataTable getFeedback()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select f.*, c.name from tblFeedback f left join tblCustomers c on f.uid = c.id order by f.active DESC, f.dtAdded DESC";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            return dt;
        }

        protected void lvFeedback_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            (lvFeedback.FindControl("dpFeedback") as DataPager).SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            this.populateTable();
        }

        protected void lvFeedback_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            string fid;
            fid = e.CommandArgument.ToString();

            if (fid == string.Empty)
            {
                setStatus(false, "An error occurred: Feedback ID not found!");
                return;
            }

            switch (e.CommandName)
            {
                case "seen":
                    seenFeedback(fid);
                    break;
                case "unseen":
                    unseenFeedback(fid);
                    break;
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

        private void seenFeedback(string fid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblFeedback SET active = 0 WHERE id= @fid";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@fid", fid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Marked as seen!");
                    populateTable();
                }
                catch (Exception e)
                {
                    transaction.Rollback();
                    setStatus(false, e.Message);
                    return;
                }
            }
        }

        private void unseenFeedback(string fid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblFeedback SET active = 1 WHERE id= @fid";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@fid", fid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Marked as unseen!");
                    populateTable();
                }
                catch (Exception e)
                {
                    transaction.Rollback();
                    setStatus(false, e.Message);
                    return;
                }
            }
        }
    }
}