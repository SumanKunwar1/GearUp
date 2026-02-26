using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Policy;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace MWM_Assignment
{
    public partial class Feedback : System.Web.UI.Page
    {
        private string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] == null)
            {
                cbShareUser.Visible = false;
            }
        }

        protected void btnSendFeedback_Click(object sender, EventArgs e)
        {
            if (txtFeedback.Text != "")
            {
                if (insertFeedback())
                {
                    setStatus(true, "We have received your feedback. Thank you for your support");
                    Thread.Sleep(1000);
                    Response.Redirect("~/");
                }
                else
                {
                    setStatus(false, "An error occurred. Please try again later");
                }
            }
            else
            {
                setStatus(false, "Text field cannot be empty!");
            }
        }

        private bool insertFeedback()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "INSERT INTO [dbo].[tblFeedback] ([uid], [feedback], [dtAdded], [active]) VALUES (@uid, @feedback, GETDATE(), 1)";

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", Session["uid"] != null ? Session["uid"] : DBNull.Value);
            comm.Parameters.AddWithValue("@feedback", txtFeedback.Text.ToString().Trim());

            int result = comm.ExecuteNonQuery();


            if (result > 0)
            {
                conn.Close();
                return true;
            }

            conn.Close();
            return false;
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