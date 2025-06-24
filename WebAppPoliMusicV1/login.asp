<%@ Language=VBScript %>
<%
' Definir las variables de conexión
Dim conn, connString
Dim username, password
Dim rs, sql
Dim userFound
Dim errorMessage

' Establecer conexión con la base de datos SQL Server
connString = "Provider=SQLOLEDB;Data Source=localhost;Initial Catalog=BDD_PoliMusic_GR2;User ID=usr_polimusic_gr2;Password=Politecnica1;"
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open connString

' Obtener los datos del formulario de login
username = Request.Form("username")
password = Request.Form("password")

' Comprobar si el formulario fue enviado
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    ' Realizar la consulta para verificar si el usuario existe y las credenciales son correctas
    sql = "SELECT * FROM TBL_USER WHERE USERNAME = '" & username & "' AND PASSWORD = '" & password & "'"
    Set rs = conn.Execute(sql)
    
    ' Verificar si se encontró un usuario con las credenciales correctas
    If Not rs.EOF Then
        ' Guardar el nombre del usuario en la sesión
        Session("username") = rs("USERNAME")
        
        ' Redirigir al usuario a la página de canciones (songs.asp)
        Response.Redirect("songs.asp")
    Else
        ' Si las credenciales no son válidas, establecer el mensaje de error
        errorMessage = "Usuario o contraseña incorrectos. Por favor intente nuevamente."
    End If
End If

' Cerrar la conexión a la base de datos
conn.Close
Set rs = Nothing
Set conn = Nothing
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - PoliMusic</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Animate.css CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Custom styles */
        body {
            background-color: #f5f5f5;
        }
        
        .card {
            background-color: #FFFFFF;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
        }
        
        .input-group {
            position: relative;
            margin-bottom: 1.5rem;
        }
        
        .input-field {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: #FFFFFF;
            color: #333333;
        }
        
        .input-field:focus {
            border-color: #E13227;
            box-shadow: 0 0 0 3px rgba(225, 50, 39, 0.2);
            outline: none;
        }
        
        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #777777;
        }
        
        .btn-login {
            background-color: #E13227;
            color: white;
            padding: 1rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
        }
        
        .btn-login:hover {
            background-color: #C12A20;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(225, 50, 39, 0.3);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .btn-login::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }
        
        .btn-login:hover::after {
            transform: translateX(0);
        }
        
        /* Notification styles */
        .notification {
            position: fixed;
            top: 1.5rem;
            right: 1.5rem;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            color: white;
            display: flex;
            align-items: center;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            z-index: 1000;
            transform: translateX(150%);
            transition: transform 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            background-color: #E13227;
        }
        
        .notification.show {
            transform: translateX(0);
        }
        
        .notification-icon {
            margin-right: 0.75rem;
            font-size: 1.25rem;
        }
        
        .notification-close {
            margin-left: 1rem;
            cursor: pointer;
            opacity: 0.7;
            transition: opacity 0.2s;
        }
        
        .notification-close:hover {
            opacity: 1;
        }
        
        /* Header styles */
        .header {
            background-color: #222222;
            color: #FFFFFF;
        }
        
        /* Footer styles */
        .footer {
            background-color: #222222;
            color: #FFFFFF;
        }
        
        /* Text colors */
        .text-primary {
            color: #333333;
        }
        
        .text-secondary {
            color: #777777;
        }
        
        .text-accent {
            color: #E13227;
        }
        
        /* Link hover effect */
        .link-hover:hover {
            color: #C12A20;
        }
        
        /* Checkbox styles */
        .checkbox:checked {
            background-color: #E13227;
            border-color: #E13227;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <header class="header py-6 px-6 flex items-center justify-between">
        <div class="flex items-center">
            <img src="Mateo_Logo.png" alt="Mateo P. Logo" class="h-12 w-auto mr-4">
            <h1 class="text-3xl font-bold text-white">PoliMusic</h1>
        </div>
    </header>

    <main class="flex-grow flex justify-center items-center px-4 py-12">
        <div class="card p-10 w-full max-w-md animate__animated animate__fadeIn">
            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-primary mb-2">Bienvenido de nuevo</h2>
                <p class="text-secondary">Ingresa tus credenciales para acceder</p>
            </div>
            
            <form method="POST" action="login.asp" class="space-y-6">
                <div class="input-group">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" required placeholder="Nombre de usuario"
                           class="input-field">
                </div>
                
                <div class="input-group">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" required placeholder="Contraseña"
                           class="input-field">
                </div>
                
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input type="checkbox" id="remember" class="h-4 w-4 rounded border-gray-300 text-accent focus:ring-accent checkbox">
                        <label for="remember" class="ml-2 block text-sm text-secondary">Recordarme</label>
                    </div>
                    
                    <a href="#" class="text-sm text-accent hover:text-red-700 link-hover">¿Olvidaste tu contraseña?</a>
                </div>
                
                <button type="submit" class="btn-login w-full">
                    Iniciar Sesión
                </button>
                
                <div class="text-center text-sm text-secondary">
                    ¿No tienes una cuenta? <a href="#" class="text-accent font-medium link-hover">Regístrate</a>
                </div>
            </form>
        </div>
    </main>

    <!-- Notification for error message -->
    <% If errorMessage <> "" Then %>
    <div id="errorNotification" class="notification">
        <i class="fas fa-exclamation-circle notification-icon"></i>
        <span class="notification-message"><%= errorMessage %></span>
        <span class="notification-close" onclick="dismissNotification()">
            <i class="fas fa-times"></i>
        </span>
    </div>
    <% End If %>

    <footer class="footer py-4 text-center text-sm">
        <p>© 2025 PoliMusic. Todos los derechos reservados.</p>
    </footer>

    <script>
        // Show notification with animation
        document.addEventListener('DOMContentLoaded', function() {
            const notification = document.getElementById('errorNotification');
            if (notification) {
                setTimeout(() => {
                    notification.classList.add('show');
                }, 100);
                
                // Auto-dismiss after 5 seconds
                setTimeout(() => {
                    dismissNotification();
                }, 5000);
            }
        });
        
        function dismissNotification() {
            const notification = document.getElementById('errorNotification');
            if (notification) {
                notification.classList.remove('show');
                setTimeout(() => {
                    notification.remove();
                }, 500);
            }
        }
        
        // Add ripple effect to button
        const buttons = document.querySelectorAll('.btn-login');
        buttons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Create ripple element
                const ripple = document.createElement('span');
                ripple.className = 'ripple';
                this.appendChild(ripple);
                
                // Get click position
                const rect = this.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                // Position the ripple
                ripple.style.left = `${x}px`;
                ripple.style.top = `${y}px`;
                
                // Remove ripple after animation
                setTimeout(() => {
                    ripple.remove();
                    this.form.submit();
                }, 600);
            });
        });
    </script>
</body>
</html>