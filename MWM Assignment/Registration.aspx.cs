using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWM_Assignment
{
    public partial class Registration : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                divStatus.Visible = false;
            }

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (txtPassword.Text == txtConfirmPassword.Text && checkNewUser())
            {
                if (insertUser())
                {
                    Response.Redirect("Login.aspx");
                }
            }
            else
            {
                setStatus(false, "Password does not match! Please try again.");
            }
        }

        private string saveImage()
        {
            string fileUrl;

            if (fuProfile.HasFile)
            {
                string ext = Path.GetExtension(fuProfile.FileName);

                string path = Server.MapPath("~//Images//Profile//");
                if (!System.IO.Directory.Exists(path))
                {
                    System.IO.Directory.CreateDirectory(path);
                }

                fuProfile.SaveAs(Server.MapPath("~//Images//Profile//" + txtEmail.Text + ext));
                fileUrl = "~/Images/Profile/" + txtEmail.Text + ext;

            }
            else
            {
                fileUrl = "~/Images/Placeholder/placeholder-user.jpg";
            }

            return fileUrl;
        }

        private bool insertUser()
        {
            string fileUrl = saveImage();
            if (fileUrl == null)
            {
                setStatus(false, "Something went wrong. Please try again.");
                return false;
            }

            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "insert into tblCustomers (name, email, password, address, contact, profilePicture, dtAdded, active) values (@name, @email, @password, @address, @contact, @profilePicture, @dtAdded, @active)";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@name", txtName.Text.Trim());
            comm.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
            comm.Parameters.AddWithValue("@password", EncodePasswordToBase64(txtPassword.Text.Trim()));
            comm.Parameters.AddWithValue("@address", txtAddress.Text.Trim());
            comm.Parameters.AddWithValue("@contact", txtPhone.Text.Trim());
            comm.Parameters.AddWithValue("@profilePicture", fileUrl);
            comm.Parameters.AddWithValue("@dtAdded", DateTime.Now);
            comm.Parameters.AddWithValue("@active", 1);

            int result = comm.ExecuteNonQuery();
            if (result > 0)
            {
                conn.Close();
                setStatus(true, "Account successfully created on " + DateTime.Now.ToString());
                return true;
            }
            else
            {
                conn.Close();
                setStatus(false, "Something went wrong. Please try again.");
                return false;
            }
        }

        private bool checkNewUser()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblCustomers WHERE email = @email";

            SqlCommand conm = new SqlCommand(query, conn);
            conm.Parameters.AddWithValue("@email", txtEmail.Text.Trim());

            SqlDataReader reader = conm.ExecuteReader();
            if (reader.Read())
            {
                setStatus(false, "User already exists! Please try again with a different email address!");
                reader.Close();
                conn.Close();
                return false;
            }
            else
            {
                reader.Close();
                conn.Close();
                return true;
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