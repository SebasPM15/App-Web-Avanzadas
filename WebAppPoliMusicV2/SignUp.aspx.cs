using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace WebAppPoliMusicV2
{
    public partial class SignUp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Limpiar el mensaje de error al cargar la página
                lblErrorMessage.Visible = false;

                // Llenar los DropDownList de fecha
                PopulateDateDropDowns();
            }
        }

        private void PopulateDateDropDowns()
        {
            // Días (1 a 31)
            for (int day = 1; day <= 31; day++)
            {
                ddlDay.Items.Add(new ListItem(day.ToString("D2"), day.ToString()));
            }

            // Meses (1 a 12, con nombres)
            string[] months = { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
                               "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" };
            for (int month = 1; month <= 12; month++)
            {
                ddlMonth.Items.Add(new ListItem(months[month - 1], month.ToString()));
            }

            // Años (desde 1900 hasta el año actual)
            int currentYear = DateTime.Now.Year;
            for (int year = 1900; year <= currentYear; year++)
            {
                ddlYear.Items.Add(new ListItem(year.ToString(), year.ToString()));
            }

            // Seleccionar valores por defecto (opcional)
            ddlDay.SelectedIndex = 0; // Día 01
            ddlMonth.SelectedIndex = 0; // Enero
            ddlYear.SelectedValue = "2000"; // Año 2000 como predeterminado
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Limpiar mensaje previo
            lblErrorMessage.Visible = false;
            lblErrorMessage.Text = "";

            // Validar campos
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string passwordConfirm = txtPasswordConfirm.Text;
            string day = ddlDay.SelectedValue;
            string month = ddlMonth.SelectedValue;
            string year = ddlYear.SelectedValue;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(password) || string.IsNullOrEmpty(passwordConfirm))
            {
                lblErrorMessage.Text = "Todos los campos son obligatorios.";
                lblErrorMessage.Visible = true;
                return;
            }

            // Validar que las contraseñas coincidan
            if (password != passwordConfirm)
            {
                lblErrorMessage.Text = "Las contraseñas no coinciden.";
                lblErrorMessage.Visible = true;
                return;
            }

            // Validar longitud mínima de la contraseña
            if (password.Length < 6)
            {
                lblErrorMessage.Text = "La contraseña debe tener al menos 6 caracteres.";
                lblErrorMessage.Visible = true;
                return;
            }

            // Validar formato de correo electrónico
            string emailPattern = @"^[^@\s]+@[^@\s]+\.[^@\s]+$";
            if (!Regex.IsMatch(email, emailPattern))
            {
                lblErrorMessage.Text = "El correo electrónico no es válido.";
                lblErrorMessage.Visible = true;
                return;
            }

            // Validar y combinar la fecha de nacimiento
            string birthdayString = $"{year}-{month.PadLeft(2, '0')}-{day.PadLeft(2, '0')}";
            if (!DateTime.TryParse(birthdayString, out DateTime birthDate))
            {
                lblErrorMessage.Text = "La fecha de nacimiento no es válida.";
                lblErrorMessage.Visible = true;
                return;
            }

            // Opcional: Validar que la fecha no sea futura
            if (birthDate > DateTime.Now)
            {
                lblErrorMessage.Text = "La fecha de nacimiento no puede ser futura.";
                lblErrorMessage.Visible = true;
                return;
            }

            // Conexión a la base de datos
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Verificar si el nombre de usuario ya existe
                    string checkUserQuery = "SELECT COUNT(*) FROM TBL_USER WHERE USERNAME = @Username";
                    using (SqlCommand checkUserCommand = new SqlCommand(checkUserQuery, connection))
                    {
                        checkUserCommand.Parameters.AddWithValue("@Username", username);
                        int userCount = (int)checkUserCommand.ExecuteScalar();
                        if (userCount > 0)
                        {
                            lblErrorMessage.Text = "El nombre de usuario ya está registrado.";
                            lblErrorMessage.Visible = true;
                            return;
                        }
                    }

                    // Verificar si el correo ya existe
                    string checkEmailQuery = "SELECT COUNT(*) FROM TBL_USER WHERE EMAIL = @Email";
                    using (SqlCommand checkEmailCommand = new SqlCommand(checkEmailQuery, connection))
                    {
                        checkEmailCommand.Parameters.AddWithValue("@Email", email);
                        int emailCount = (int)checkEmailCommand.ExecuteScalar();
                        if (emailCount > 0)
                        {
                            lblErrorMessage.Text = "El correo electrónico ya está registrado.";
                            lblErrorMessage.Visible = true;
                            return;
                        }
                    }

                    // Insertar nuevo usuario (contraseña en texto plano)
                    string insertQuery = "INSERT INTO TBL_USER (USERNAME, PASSWORD, EMAIL, BIRTHDAY) " +
                                        "VALUES (@Username, @Password, @Email, @Birthday)";
                    using (SqlCommand insertCommand = new SqlCommand(insertQuery, connection))
                    {
                        insertCommand.Parameters.AddWithValue("@Username", username);
                        insertCommand.Parameters.AddWithValue("@Password", password); // Sin hashear
                        insertCommand.Parameters.AddWithValue("@Email", email);
                        insertCommand.Parameters.AddWithValue("@Birthday", birthDate);
                        insertCommand.ExecuteNonQuery();
                    }

                    // Guardar USERNAME en la sesión para uso en Songs.aspx
                    Session["FirstName"] = username;
                    Session["LastName"] = "";

                    // Redirigir a Login.aspx
                    Response.Redirect("~/Login.aspx", false);
                    return;
                }
                catch (Exception ex)
                {
                    lblErrorMessage.Text = "Error al registrar el usuario: " + ex.Message;
                    lblErrorMessage.Visible = true;
                }
            }
        }
    }
}