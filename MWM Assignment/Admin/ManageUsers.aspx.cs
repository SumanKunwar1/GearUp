using Antlr.Runtime.Tree;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace MWM_Assignment.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            MasterPage masterPage = (MasterPage)this.Master;
            HtmlAnchor anchor = (HtmlAnchor)masterPage.FindControl("hUsers");
            anchor.Attributes["class"] = "nav_link active";

            if (!IsPostBack)
            {
                populateTable();
            }
        }

        private void populateTable()
        {
            divUserDetails.Visible = false;

            DataTable users = getUsers();
            lvUser.DataSource = users;
            lvUser.DataBind();

        }

        private DataTable getUsers()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblCustomers ORDER BY active DESC";

            SqlDataAdapter da = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();

            da.Fill(dt);

            return dt;
        }

        protected void lvUser_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            string uid;
            uid = e.CommandArgument.ToString();

            if (uid == string.Empty)
            {
                setStatus(false, "An error occurred: User ID not found!");
                return;
            }

            hfUid.Value = uid;

            switch (e.CommandName)
            {
                case "updateUser":
                    populateUserDetails(uid);
                    divUserDetails.Visible = true;
                    break;
                case "deleteUser":
                    deleteUser(uid);
                    break;
                case "restoreUser":
                    restoreUser(uid);
                    break;
            }
        }

        private void populateUserDetails(string uid)
        {
            DataTable dt = getUser(uid);

            if (dt.Rows.Count > 0)
            {
                txtName.Text = dt.Rows[0]["name"].ToString().Trim();
                txtEmail.Text = dt.Rows[0]["email"].ToString().Trim();
                txtAddress.Text = dt.Rows[0]["address"].ToString().Trim();
                txtPhone.Text = dt.Rows[0]["contact"].ToString().Trim();
                profileImage.Attributes["src"] = dt.Rows[0]["profilePicture"].ToString().Trim();
            }
        }

        private DataTable getUser(string uid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblCustomers WHERE id = @id";

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("id", uid);

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

        private void deleteUser(string uid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblCustomers SET active = 0 WHERE id= @id";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@id", uid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Account has been deactivated");
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

        private void restoreUser(string uid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblCustomers SET active = 1 WHERE id= @id";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@id", uid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Account has been reactivated!");
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

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string uid = hfUid.Value.ToString();

            if (uid == string.Empty) return;

            updateUser(uid);
            populateTable();

        }

        private void updateUser(string uid)
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    if (txtName.Text != "")
                    {
                        // Query
                        string query = "UPDATE tblCustomers SET name = @name WHERE id=@id";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@name", txtName.Text.Trim());
                        comm.Parameters.AddWithValue("@id", uid);

                        comm.ExecuteNonQuery();
                    }

                    if (txtAddress.Text != "")
                    {
                        // Query
                        string query = "UPDATE tblCustomers SET address = @address WHERE id=@id";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@address", txtAddress.Text.Trim());
                        comm.Parameters.AddWithValue("@id", uid);

                        comm.ExecuteNonQuery();
                    }

                    if (txtPhone.Text != "")
                    {
                        // Query
                        string query = "UPDATE tblCustomers SET contact = @contact WHERE id=@id";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@contact", txtPhone.Text.Trim());
                        comm.Parameters.AddWithValue("@id", uid);

                        comm.ExecuteNonQuery();
                    }

                    if (fuProfile.HasFile)
                    {
                        string url = updateImage();
                        string query = "UPDATE tblCustomers SET profilePicture = @profilePicture WHERE id=@id";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@profilePicture", url);
                        comm.Parameters.AddWithValue("@id", uid);

                        comm.ExecuteNonQuery();
                    }

                    transaction.Commit();
                    setStatus(true, "User Details has been updated successfully!");
                    conn.Close();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    setStatus(false, ex.Message);
                    conn.Close();
                }
            }
        }

        string updateImage()
        {
            string fileUrl;

            if (fuProfile.HasFile)
            {
                string ext = Path.GetExtension(fuProfile.FileName);

                string directory = Server.MapPath("~//Images//Profile//");
                if (!System.IO.Directory.Exists(directory))
                {
                    System.IO.Directory.CreateDirectory(directory);
                }
                string[] files = Directory.GetFiles(directory);

                foreach (string file in files)
                {
                    if (Path.GetFileNameWithoutExtension(file) == txtEmail.Text.ToString())
                    {
                        System.IO.File.Delete(file);
                    }
                }

                string filePath = Server.MapPath("~//Images//Profile//" + txtEmail.Text + ext);

                fuProfile.SaveAs(filePath);

                fileUrl = "~/Images/Profile/" + txtEmail.Text + ext;
            }
            else
            {
                fileUrl = "~/Images/Placeholder/placeholder-user.jpg";
            }

            return fileUrl;
        }

        protected void lvUser_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            (lvUser.FindControl("dpUser") as DataPager).SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            this.populateTable();
        }
    }
}