using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

namespace MWM_Assignment.Admin
{
    public partial class ManageCategory : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            MasterPage masterPage = (MasterPage)this.Master;
            HtmlAnchor anchor = (HtmlAnchor)masterPage.FindControl("hCategories");
            anchor.Attributes["class"] = "nav_link active";

            if (!IsPostBack) populateTable();

            btnCancel.Visible = false;
        }

        private void populateTable()
        {
            divCategoryDetails.Visible = false;

            DataTable categories = getCategories();

            lvCategory.DataSource = categories;
            lvCategory.DataBind();
        }

        private DataTable getCategories()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblCategory ORDER BY active DESC";

            SqlDataAdapter da = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();

            da.Fill(dt);

            return dt;
        }


        protected void lvCategory_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            (lvCategory.FindControl("dpCategory") as DataPager).SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            this.populateTable();
        }

        protected void lvCategory_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            string cid;
            cid = e.CommandArgument.ToString();

            if (cid == string.Empty)
            {
                setStatus(false, "An error occurred: Category ID not found!");
                return;
            }

            hfUid.Value = cid;

            switch (e.CommandName)
            {
                case "updateCategory":
                    btnUpdate.Visible = true;
                    btnCancel.Visible = true;
                    btnShowCreate.Visible = false;
                    btnCreate.Visible = false;

                    populateCategoryDetails(cid);
                    divCategoryDetails.Visible = true;
                    break;
                case "deleteCategory":
                    deleteCategory(cid);
                    break;
                case "restoreCategory":
                    restoreCategory(cid);
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

        private void deleteCategory(string cid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblCategory SET active = 0 WHERE cid= @cid";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@cid", cid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Category has been deactivated");
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

        private void restoreCategory(string cid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblCategory SET active = 1 WHERE cid= @cid";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@cid", cid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Category has been reactivated!");
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

        private void populateCategoryDetails(string cid)
        {
            DataTable dt = getCategory(cid);

            if (dt.Rows.Count > 0)
            {
                txtName.Text = dt.Rows[0]["name"].ToString().Trim();
                categoryImage.Attributes["src"] = dt.Rows[0]["image"].ToString().Trim();
            }
        }

        private DataTable getCategory(string cid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblCategory WHERE cid = @cid";

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("cid", cid);

            SqlDataAdapter da = new SqlDataAdapter(comm);

            DataTable dt = new DataTable();

            da.Fill(dt);

            return dt;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string uid = hfUid.Value.ToString();

            if (uid == string.Empty) return;

            updateCategory(uid);
            populateTable();
        }

        private void updateCategory(string cid)
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
                        string query = "UPDATE tblCategory SET name = @name WHERE cid=@cid";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@name", txtName.Text.Trim());
                        comm.Parameters.AddWithValue("@cid", cid);

                        comm.ExecuteNonQuery();
                    }

                    if (fuCategory.HasFile)
                    {
                        string url = updateImage();
                        string query = "UPDATE tblCategory SET image = @image WHERE cid=@cid";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@image", url);
                        comm.Parameters.AddWithValue("@cid", cid);

                        comm.ExecuteNonQuery();
                    }

                    transaction.Commit();
                    setStatus(true, "Category Details has been updated successfully!");
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

        private string updateImage()
        {
            string fileUrl;

            if (fuCategory.HasFile)
            {
                string ext = Path.GetExtension(fuCategory.FileName);

                string directory = Server.MapPath("~//Images//Category//");
                if (!System.IO.Directory.Exists(directory))
                {
                    System.IO.Directory.CreateDirectory(directory);
                }
                string[] files = Directory.GetFiles(directory);

                foreach (string file in files)
                {
                    if (Path.GetFileNameWithoutExtension(file) == txtName.Text.ToString())
                    {
                        System.IO.File.Delete(file);
                    }
                }

                string filePath = Server.MapPath("~//Images//Category//" + txtName.Text + ext);

                fuCategory.SaveAs(filePath);

                fileUrl = "~/Images/Category/" + txtName.Text + ext;
            }
            else
            {
                fileUrl = "~/Images/Placeholder/placeholder.jpg";
            }

            return fileUrl;
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            if (createCategory())
            {
                setStatus(true, "Category created successully!");
                divCategoryDetails.Visible = false;
                btnCreate.Visible = false;
            }
        }

        private bool createCategory()
        {
            string url = updateImage();

            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "insert into tblCategory (name, image, dtAdded, active) values (@name, @image, GETDATE(), 1)";

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@name", txtName.Text.ToString().Trim());
            comm.Parameters.AddWithValue("@image", url);

            int result = comm.ExecuteNonQuery();
            if (result > 0)
            {
                conn.Close();
                return true;
            }

            conn.Close();
            return false;
        }

        protected void btnShowCreate_Click(object sender, EventArgs e)
        {
            btnShowCreate.Visible = false;
            divCategoryDetails.Visible = true;
            btnCreate.Visible = true;
            btnCancel.Visible = true;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            divCategoryDetails.Visible = false;

            btnShowCreate.Visible = true;
            btnCancel.Visible = false;
            btnCreate.Visible = false;

            btnUpdate.Visible = false;
        }
    }
}