using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV2
{
    public partial class Songs : System.Web.UI.Page
    {
        // Array con las rutas de las canciones
        private readonly string[] songFiles = new string[]
        {
            "bensound-adventure.mp3",
            "bensound-dreams.mp3",
            "bensound-energy.mp3",
            "bensound-scifi.mp3",
            "bensound-tomorrow.mp3"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    // Verificar autenticación
                    if (User.Identity.IsAuthenticated && Session["FirstName"] != null)
                    {
                        // Mostrar USERNAME como nombre visible
                        lblUserName.Text = Session["FirstName"].ToString();
                    }
                    else
                    {
                        // Redirigir a Login si no está autenticado o no hay datos en la sesión
                        Response.Redirect("~/Login.aspx", false);
                        return; // Detener el procesamiento de la página
                    }

                    // Cargar las canciones
                    LoadSongs();
                }
            }
            catch (Exception ex)
            {
                lblUserName.Text = "Error en la página: " + ex.Message;
            }
        }

        private void LoadSongs()
        {
            try
            {
                DataTable dt = GetSongsDataTable();
                if (dt != null)
                {
                    // Asignar rutas cíclicas desde songFiles
                    dt.Columns.Add("SongFile", typeof(string));
                    dt.Columns.Add("RowIndex", typeof(int));

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        int songIndex = i % songFiles.Length;
                        dt.Rows[i]["SongFile"] = songFiles[songIndex];
                        dt.Rows[i]["RowIndex"] = i;
                    }

                    // Asignar el DataTable al Repeater
                    rptSongs.DataSource = dt;
                    rptSongs.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblUserName.Text = "Error al cargar las canciones: " + ex.Message;
            }
        }

        private DataTable GetSongsDataTable()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT [ID_SONG], [SONG_NAME], [PLAYS], [SONG_PATH] FROM [BDD_PoliMusic_GR2].[dbo].[TBL_SONG]";
                if (ViewState["SortExpression"] != null)
                {
                    query += " ORDER BY " + ViewState["SortExpression"] + " " + ViewState["SortDirection"];
                }
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    try
                    {
                        connection.Open();
                        SqlDataAdapter adapter = new SqlDataAdapter(command);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        return dt;
                    }
                    catch (Exception ex)
                    {
                        lblUserName.Text = "Error al conectar con la base de datos: " + ex.Message;
                        return null;
                    }
                }
            }
        }

        protected void SortSongs(object sender, EventArgs e)
        {
            try
            {
                LinkButton lnkButton = (LinkButton)sender;
                string sortExpression = lnkButton.CommandArgument;

                string sortDirection = "ASC";
                if (ViewState["SortExpression"] != null && ViewState["SortExpression"].ToString() == sortExpression)
                {
                    sortDirection = ViewState["SortDirection"].ToString() == "ASC" ? "DESC" : "ASC";
                }

                ViewState["SortExpression"] = sortExpression;
                ViewState["SortDirection"] = sortDirection;

                LoadSongs();
            }
            catch (Exception ex)
            {
                lblUserName.Text = "Error al ordenar: " + ex.Message;
            }
        }

        protected void linkButtonCloseSession_Click(object sender, EventArgs e)
        {
            try
            {
                // Cerrar la sesión
                FormsAuthentication.SignOut();
                Session.Abandon();

                // Redirigir a Login.aspx sin terminar el hilo
                Response.Redirect("~/Login.aspx", false);
                return;
            }
            catch (Exception ex)
            {
                lblUserName.Text = "Error al cerrar sesión: " + ex.Message;
            }
        }
    }
}