using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWM_Assignment
{
    public partial class ProductCatalog : System.Web.UI.Page
    {
        private string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadCategories();
                loadProducts();

                string cid = Request.QueryString["cid"];
                if (cid != null)
                {
                    ddlCategoryFilter.SelectedValue = cid;
                    DataTable dt = getProductsByCategories(cid);
                    ListView1.DataSource = dt;
                    ListView1.DataBind();
                }

            }
        }

        protected void ListView1_ItemCommand1(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "showDetails")
            {
                string pid = "";

                // Command Argument Method
                pid = e.CommandArgument.ToString();

                // Find Control Method
                Label pidLabel = e.Item.FindControl("pidLabel") as Label;
                pid = pidLabel.Text;

                Session["pid"] = pid;

                Response.Redirect("ProductDetails.aspx");
            }
        }

        protected void ddlCategoryFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            string cid = ddlCategoryFilter.SelectedValue;
            DataTable dt = new DataTable();


            if (cid == "-1")
            {
                dt = getProducts();
            }
            else
            {
                dt = getProductsByCategories(cid);
            }

            ListView1.DataSource = dt;
            ListView1.DataBind();

            ddlPriceFilter.SelectedValue = "-1";
        }

        protected void ddlPriceFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();

            switch (ddlPriceFilter.SelectedValue)
            {
                case "-1":
                    dt = getProducts();
                    ListView1.DataSource = dt;
                    ListView1.DataBind();
                    break;
                case "0":
                    dt = getProductsbyPrice(true);
                    ListView1.DataSource = dt;
                    ListView1.DataBind();
                    break;
                case "1":
                    dt = getProductsbyPrice(false); ;
                    ListView1.DataSource = dt;
                    ListView1.DataBind();
                    break;
            }

            ddlCategoryFilter.SelectedValue = "-1";
        }

        private void loadCategories()
        {
            DataTable dt = getCategories();
            DataRow dr = dt.NewRow();
            dr["name"] = "No Filters";
            dr["cid"] = -1;
            dt.Rows.InsertAt(dr, 0);

            ddlCategoryFilter.DataSource = dt;
            ddlCategoryFilter.DataTextField = "name";
            ddlCategoryFilter.DataValueField = "cid";
            ddlCategoryFilter.DataBind();
        }

        private void loadProducts()
        {
            DataTable dt = getProducts();

            ListView1.DataSource = dt;
            ListView1.DataBind();
        }

        private DataTable getProducts()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select * from tblProducts p inner join tblCategory c on p.cid = c.cid where c.active = 1 and p.active = 1";

            // SQL Command
            SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();
            adapter.Fill(dt);

            conn.Close();
            return dt;
        }

        private DataTable getProductsByCategories(string cid)
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select * from tblProducts p inner join tblCategory c on p.cid = c.cid where c.active = 1 and p.active = 1 and c.cid = @cid";

            // SQL Command
            SqlCommand comm = new SqlCommand(query, conn);
            comm.Parameters.AddWithValue("@cid", cid);

            SqlDataAdapter da = new SqlDataAdapter(comm);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();
            return dt;
        }

        private DataTable getProductsbyPrice(bool asc)
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select * from tblProducts p inner join tblCategory c on p.cid = c.cid where c.active = 1 and p.active = 1";

            if (asc)
            {
                query += "order by price asc";
            }
            else
            {
                query += "order by price desc";
            }

            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);

            conn.Close();
            return dt;
        }

        private DataTable getCategories()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select * from tblCategory where active = 1";

            // SQL Command
            SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();
            adapter.Fill(dt);

            conn.Close();
            return dt;
        }
    }
}