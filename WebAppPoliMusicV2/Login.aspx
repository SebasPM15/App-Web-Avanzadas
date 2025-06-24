<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebAppPoliMusicV2.Login" %>

<!DOCTYPE html>

<html lang="es" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Iniciar Sesión - PoliMusic</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            background-color: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .header {
            background-color: #222222;
            color: #FFFFFF;
        }
        .card {
            background-color: #FFFFFF;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
        }
        .btn-primary {
            background-color: #E13227;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #C12A20;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(225, 50, 39, 0.3);
        }
        .input-field {
            padding: 0.75rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background-color: #FFFFFF;
            color: #333333;
            transition: all 0.3s ease;
            width: 100%;
        }
        .input-field:focus {
            border-color: #E13227;
            box-shadow: 0 0 0 3px rgba(225, 50, 39, 0.2);
            outline: none;
        }
        .error-message {
            color: #E13227;
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }
        .link {
            color: #E13227;
            text-decoration: none;
            font-weight: 600;
        }
        .link:hover {
            text-decoration: underline;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.5s ease-out;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <form id="form1" runat="server">
        <header class="header py-4 px-6 flex items-center">
            <div class="flex items-center">
                <img src="Mateo_Logo.png" alt="Mateo P. Logo" class="h-10 w-auto mr-3" />
                <h1 class="text-2xl font-bold">PoliMusic</h1>
            </div>
        </header>
        
        <main class="flex-grow container mx-auto px-4 py-8">
            <div class="animate-fade-in">
                <div class="card p-6 max-w-md mx-auto">
                    <h2 class="text-2xl font-semibold text-center mb-6 text-[#333333]">Iniciar Sesión</h2>
                    <div class="mb-4">
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="input-field" placeholder=""></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="input-field" TextMode="Password" placeholder=""></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="btn-primary w-full" OnClick="btnLogin_Click" />
                    </div>
                    <div class="text-center">
                        <asp:Label ID="lblErrorMessage" runat="server" CssClass="error-message" Visible="False"></asp:Label>
                    </div>
                    <div class="text-center mt-4">
                        <a href="SignUp.aspx" class="link">¿No tienes una cuenta? Regístrate</a>
                    </div>
                </div>
            </div>
        </main>
        
        <footer class="footer py-4 text-center">
            <p class="text-sm">© 2025 PoliMusic. Todos los derechos reservados.</p>
        </footer>
    </form>
    
    <script>
        // Generar placeholders aleatorios
        window.onload = function () {
            const usernames = ['musicLover', 'songMaster', 'beatFan', 'melodyKing', 'rhythmStar'];
            const passwords = ['tune1234', 'play5678', 'sound4321', 'vibe8765', 'harmony111'];

            const randomUsername = usernames[Math.floor(Math.random() * usernames.length)];
            const randomPassword = passwords[Math.floor(Math.random() * passwords.length)];

            document.getElementById('<%= txtUsername.ClientID %>').placeholder = randomUsername;
            document.getElementById('<%= txtPassword.ClientID %>').placeholder = randomPassword;
        };
    </script>
</body>
</html>