using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace MWM_Assignment
{
    public partial class SiteMaster : MasterPage
    {
        private string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] != null)
            {
                hLogin.Visible = false;
                hRegister.Visible = false;
                cartCount.Text = getCartCount();
            }
            else
            {
                hCart.Visible = false;
                navbarDropdown.Visible = false;
                lbLogout.Visible = false;
            }

            if (Session["profileImg"] != null && Session["name"] != null)
            {
                imgProfile.ImageUrl = Session["profileImg"].ToString();
                lblProfile.Text = Session["name"].ToString();
            }

        }

        protected void lbLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/");
        }

        private string getCartCount()
        {
            string count="";

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            int uid = int.Parse(Session["uid"].ToString());

            string query = "select count(*) as 'count' from tblShoppingCart where uid = @uid and status='Pending'";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@uid", uid);

            SqlDataReader reader = comm.ExecuteReader();
            if (reader.Read())
            {
                count = reader["count"].ToString();

            }
            reader.Close();
            conn.Close();
            return count;
        }
    }
}