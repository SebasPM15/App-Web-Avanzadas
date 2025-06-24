using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;

namespace WebAppPoliMusicV2
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Limpiar mensaje de error
                lblErrorMessage.Visible = false;
                lblErrorMessage.Text = string.Empty;

                // Evitar que la página se cargue en un iframe
                ClientScript.RegisterStartupScript(GetType(), "Load", "<script type='text/javascript'>if (window.parent != window.top) window.parent.location.href = window.location.origin+'/Login.aspx';</script>");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblErrorMessage.Text = "Por favor, ingrese un nombre de usuario y contraseña.";
                lblErrorMessage.Visible = true;
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;
            DataTable dtUser = AuthenticateUser(username, password, connectionString);

            if (dtUser != null && dtUser.Rows.Count > 0)
            {
                // Guardar USERNAME en la sesión para Songs.aspx
                Session["FirstName"] = username;
                Session["LastName"] = "";

                // Autenticar al usuario sin redirigir automáticamente
                FormsAuthentication.SetAuthCookie(username, true);

                // Redirigir a Songs.aspx sin terminar el hilo
                Response.Redirect("~/Songs.aspx", false);
                return;
            }
            else
            {
                lblErrorMessage.Text = "Nombre de usuario o contraseña incorrectos.";
                lblErrorMessage.Visible = true;
            }
        }

        private DataTable AuthenticateUser(string username, string password, string connectionString)
        {
            DataTable dtUser = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT [ID_USER], [USERNAME], [EMAIL], [BIRTHDAY] " +
                "FROM [BDD_PoliMusic_GR2].[dbo].[TBL_USER] " +
                "WHERE [USERNAME] = @Username AND [PASSWORD] = @Password";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password); // Comparar en texto plano
                    try
                    {
                        con.Open();
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            sda.Fill(dtUser);
                        }
                    }
                    catch (Exception)
                    {
                        // Manejo de errores
                        return null;
                    }
                }
            }
            return dtUser;
        }
    }
}