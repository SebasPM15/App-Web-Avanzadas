using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace WebAppPoliMusicV2
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Cerrar la sesión
            FormsAuthentication.SignOut();
            Session.Abandon();

            // Redirigir a Login.aspx sin terminar el hilo
            Response.Redirect("~/Login.aspx", false);
            return;
        }
    }
}