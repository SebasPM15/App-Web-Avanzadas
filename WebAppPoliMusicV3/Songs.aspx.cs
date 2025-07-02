using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV3
{
    public partial class Songs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Login.aspx");
            }

            litUsername.Text = User.Identity.Name;

            if (!IsPostBack)
            {
                BindSongs();
            }
        }

        private void BindSongs()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;
            BusinesLayer.PoliMusicV3.Song songBLL = new BusinesLayer.PoliMusicV3.Song(connectionString);
            DataTable dt = songBLL.Read(txtSearch.Text);
            gvSongs.DataSource = dt;
            gvSongs.DataBind();
        }
    }
}