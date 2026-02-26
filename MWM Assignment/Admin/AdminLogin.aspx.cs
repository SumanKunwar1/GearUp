using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWM_Assignment
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            divStatus.Visible = false;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {

            if (txtUsername.Text == string.Empty || txtPassword.Text == string.Empty)
            {
                setStatus(false, "One or more fields are empty!");
                return;
            }

            if (login())
            {
                setStatus(true, "Login Successful! Welcome back.");
                Response.Redirect("~/Admin/ManageUsers.aspx");
            }
            else
            {
                setStatus(false, "Login Failed! Please try again!");
            }
        }

        private bool login()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblAdmin WHERE username = @username AND password = @password AND active = 1";

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@username", txtUsername.Text.Trim());
            comm.Parameters.AddWithValue("@password", EncodePasswordToBase64(txtPassword.Text.Trim()));

            SqlDataReader reader = comm.ExecuteReader();

            if (reader.Read())
            {
                Session["admin"] = reader["id"];
                Session["adminName"] = reader["username"];

                reader.Close();
                conn.Close();
                return true;
            }
            else
            {
                reader.Close();
                conn.Close();
                return false;
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

        public static string EncodePasswordToBase64(string password)
        {
            try
            {
                byte[] encData_byte = new byte[password.Length];
                encData_byte = System.Text.Encoding.UTF8.GetBytes(password);
                string encodedData = Convert.ToBase64String(encData_byte);
                return encodedData;
            }
            catch (Exception ex)
            {
                throw new Exception("Error in base64Encode" + ex.Message);
            }
        }
        //this function Convert to Decord your Password
        public string DecodeFrom64(string encodedData)
        {
            System.Text.UTF8Encoding encoder = new System.Text.UTF8Encoding();
            System.Text.Decoder utf8Decode = encoder.GetDecoder();
            byte[] todecode_byte = Convert.FromBase64String(encodedData);
            int charCount = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
            char[] decoded_char = new char[charCount];
            utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
            string result = new String(decoded_char);
            return result;
        }
    }
}