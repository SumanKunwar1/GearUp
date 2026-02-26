using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using System.Security.Cryptography;

namespace MWM_Assignment.Admin
{
    public partial class ManageProducts : System.Web.UI.Page
    {
        private readonly string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            MasterPage masterPage = (MasterPage)this.Master;
            HtmlAnchor anchor = (HtmlAnchor)masterPage.FindControl("hProducts");
            anchor.Attributes["class"] = "nav_link active";

            if (!IsPostBack)
            {
                populateTable();
                populateCategory();
            }

            btnCancel.Visible = false;

        }

        private void populateTable()
        {
            divProductDetails.Visible = false;
            DataTable dt = getProducts();
            lvProduct.DataSource = dt;
            lvProduct.DataBind();
        }

        private void populateCategory()
        {
            DataTable dt = getCategories();

            ddlCategory.DataSource = dt;
            ddlCategory.DataValueField = "cid";
            ddlCategory.DataTextField = "name";

            ddlCategory.DataBind();

        }

        private DataTable getProducts()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT *, p.name as 'prodName', c.name as 'catName' FROM tblProducts p INNER JOIN tblCategory c ON p.cid = c.cid ORDER BY p.active DESC";

            SqlDataAdapter da = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();

            da.Fill(dt);

            return dt;
        }


        protected void lvProduct_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            (lvProduct.FindControl("dpProduct") as DataPager).SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            this.populateTable();
        }

        protected void lvProduct_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            string pid;
            pid = e.CommandArgument.ToString();

            if (pid == string.Empty)
            {
                setStatus(false, "An error occurred: Product ID not found!");
                return;
            }

            hfUid.Value = pid;

            switch (e.CommandName)
            {
                case "updateProduct":

                    btnUpdate.Visible = true;
                    btnCancel.Visible = true;
                    btnShowCreate.Visible = false;
                    btnCreate.Visible = false;

                    populateUserDetails(pid);
                    divProductDetails.Visible = true;
                    break;
                case "deleteProduct":
                    deleteProduct(pid);
                    break;
                case "restoreProduct":
                    restoreProduct(pid);
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

        private void deleteProduct(string pid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblProducts SET active = 0 WHERE pid= @pid";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@pid", pid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Product has been deactivated");
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

        private void restoreProduct(string pid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Query
                    string query = "UPDATE tblProducts SET active = 1 WHERE pid= @pid";
                    SqlCommand comm = new SqlCommand(query, conn, transaction);
                    comm.Parameters.AddWithValue("@pid", pid);

                    comm.ExecuteNonQuery();

                    transaction.Commit();
                    setStatus(true, "Product has been reactivated!");
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

        private void populateUserDetails(string pid)
        {
            DataTable dt = getProduct(pid);

            if (dt.Rows.Count > 0)
            {
                txtName.Text = dt.Rows[0]["name"].ToString().Trim();
                txtDescription.Text = HttpUtility.HtmlDecode(dt.Rows[0]["description"].ToString());
                txtPrice.Text = string.Format("{0:C}", dt.Rows[0]["price"].ToString().Trim());
                productImage.Attributes["src"] = dt.Rows[0]["image"].ToString().Trim();
                ddlCategory.SelectedValue = dt.Rows[0]["cid"].ToString().Trim();
            }
        }

        private DataTable getProduct(string pid)
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT *, p.name as 'prodName', c.name as 'catName' FROM tblProducts p INNER JOIN tblCategory c ON p.cid = c.cid WHERE pid = @pid";

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("pid", pid);

            SqlDataAdapter da = new SqlDataAdapter(comm);

            DataTable dt = new DataTable();

            da.Fill(dt);

            return dt;
        }

        private DataTable getCategories()
        {
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "SELECT * FROM tblCategory WHERE active = 1";

            SqlDataAdapter da = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();

            da.Fill(dt);

            return dt;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string pid = hfUid.Value.ToString();

            if (pid == string.Empty) return;

            updateProduct(pid);
            populateTable();
        }

        private void updateProduct(string pid)
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
                        string query = "UPDATE tblProducts SET name = @name WHERE pid=@pid";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@name", txtName.Text.Trim());
                        comm.Parameters.AddWithValue("@pid", pid);

                        comm.ExecuteNonQuery();
                    }

                    if (txtDescription.Text != "")
                    {
                        // Query
                        string query = "UPDATE tblProducts SET description = @description WHERE pid=@pid";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@description", HttpUtility.HtmlEncode(txtDescription.Text));
                        comm.Parameters.AddWithValue("@pid", pid);

                        comm.ExecuteNonQuery();
                    }

                    if (txtPrice.Text != "")
                    {
                        // Query
                        string query = "UPDATE tblProducts SET price = @price WHERE pid=@pid";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@price", txtPrice.Text.Trim());
                        comm.Parameters.AddWithValue("@pid", pid);

                        comm.ExecuteNonQuery();
                    }

                    if (ddlCategory.SelectedItem != null)
                    {
                        // Query
                        string query = "UPDATE tblProducts SET cid = @cid WHERE pid=@pid";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@cid", ddlCategory.SelectedValue);
                        comm.Parameters.AddWithValue("@pid", pid);

                        comm.ExecuteNonQuery();
                    }

                    if (fuImage.HasFile)
                    {
                        string url = updateImage();
                        string query = "UPDATE tblProducts SET image = @image WHERE pid=@pid";
                        SqlCommand comm = new SqlCommand(query, conn, transaction);
                        comm.Parameters.AddWithValue("@image", url);
                        comm.Parameters.AddWithValue("@pid", pid);

                        comm.ExecuteNonQuery();
                    }

                    transaction.Commit();
                    setStatus(true, "Product Details has been updated successfully!");
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

            if (fuImage.HasFile)
            {
                string ext = Path.GetExtension(fuImage.FileName);

                string directory = Server.MapPath("~//Images//" + ddlCategory.SelectedItem.Text + "//");
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

                string filePath = Server.MapPath("~//Images//" + ddlCategory.SelectedItem.Text + "//" + txtName.Text + ext);

                fuImage.SaveAs(filePath);

                fileUrl = "~/Images/" + ddlCategory.SelectedItem.Text + "/" + txtName.Text + ext;
            }
            else
            {
                fileUrl = "~/Images/Placeholder/placeholder.jpg";
            }

            return fileUrl;
        }

        protected void btnShowCreate_Click(object sender, EventArgs e)
        {
            btnShowCreate.Visible = false;
            divProductDetails.Visible = true;
            btnCreate.Visible = true;
            btnCancel.Visible = true;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            divProductDetails.Visible = false;
            btnShowCreate.Visible = true;
            btnCancel.Visible = false;
            btnCreate.Visible = false;
            btnUpdate.Visible = false;
        }

        private bool createCategory()
        {
            string url = updateImage();

            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "insert into tblProducts (name, description, price, image, cid, dtAdded, active) values (@name, @description, @price, @image, @cid, GETDATE(), 1)";

            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@name", txtName.Text.ToString().Trim());
            comm.Parameters.AddWithValue("@description", txtDescription.Text.ToString());
            comm.Parameters.AddWithValue("@price", txtPrice.Text.ToString().Trim());
            comm.Parameters.AddWithValue("@image", url);
            comm.Parameters.AddWithValue("@cid", ddlCategory.SelectedValue);

            int result = comm.ExecuteNonQuery();
            if (result > 0)
            {
                conn.Close();
                return true;
            }

            conn.Close();
            return false;
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            if (createCategory())
            {
                setStatus(true, "Product added successully!");
                divProductDetails.Visible = false;
                btnCreate.Visible = false;
            }
        }

    }
}