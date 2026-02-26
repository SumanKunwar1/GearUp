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
    public partial class _Default : Page
    {
        private string strConn = ConfigurationManager.ConnectionStrings["GearUpDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                loadProducts();
                loadCategories();
            }
        }
        private void loadProducts()
        {
            DataTable dt = getRandomProducts();
            lvCarousel.DataSource = dt;
            lvCarousel.DataBind();

            DataTable dt2 = getTopProducts();
            lvTopProducts.DataSource = dt2;
            lvTopProducts.DataBind();
            
        }

        private void loadCategories()
        {
            DataTable dt = getCategory();
            lvCategories.DataSource = dt;
            lvCategories.DataBind();
        }

        protected string getActiveClass(int index)
        {
            if (index == 0)
            {
                return "active";
            }
            else
            {
                return "";
            }
        }


        private DataTable getRandomProducts()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select top(5) * from tblProducts order by newid()";

            // SQL Command
            SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();
            adapter.Fill(dt);

            conn.Close();
            return dt;
        }

        private DataTable getTopProducts()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select top(4) o.pid, p.name, p.image, p.price, sum(qty) as 'qtysold' from tblProducts p inner join tblOrders o on p.pid = o.pid where o.status != 'Cancelled' group by o.pid, p.name, p.image, p.price order by sum(qty) desc";

            // SQL Command
            SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();
            adapter.Fill(dt);

            conn.Close();
            return dt;
        }

        private DataTable getCategory()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            string query = "select * from tblcategory where active = 1";

            // SQL Command
            SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();
            adapter.Fill(dt);

            conn.Close();
            return dt;
        }

        protected void lvCategories_ItemCommand(object sender, ListViewCommandEventArgs e)
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


        private DataTable getProducts()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select * from tblProducts";

            // SQL Command
            SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();
            adapter.Fill(dt);

            conn.Close();
            return dt;
        }

        private DataTable getCategories()
        {
            // Open Connection
            SqlConnection conn = new SqlConnection(strConn);
            conn.Open();

            // Query
            string query = "select * from tblCategory";

            // SQL Command
            SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

            DataTable dt = new DataTable();
            adapter.Fill(dt);

            conn.Close();
            return dt;
        }
    }
}