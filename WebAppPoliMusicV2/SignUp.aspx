<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="WebAppPoliMusicV2.SignUp" %>

<!DOCTYPE html>

<html lang="es" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registro - PoliMusic</title>
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
        .footer {
            background-color: #222222;
            color: #FFFFFF;
            margin-top: auto;
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
        .date-select {
            padding: 0.75rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background-color: #FFFFFF;
            color: #333333;
            transition: all 0.3s ease;
        }
        .date-select:focus {
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
                    <h2 class="text-2xl font-semibold text-center mb-6 text-[#333333]">Registrar Nuevo Usuario</h2>
                    <div class="mb-4">
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="input-field" placeholder="Nombre de usuario"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="input-field" placeholder="Correo electrónico" TextMode="SingleLine"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="input-field" TextMode="Password" placeholder="Contraseña"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <asp:TextBox ID="txtPasswordConfirm" runat="server" CssClass="input-field" TextMode="Password" placeholder="Confirmar contraseña"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 mb-2">Fecha de nacimiento</label>
                        <div class="flex space-x-2">
                            <asp:DropDownList ID="ddlDay" runat="server" CssClass="date-select"></asp:DropDownList>
                            <asp:DropDownList ID="ddlMonth" runat="server" CssClass="date-select"></asp:DropDownList>
                            <asp:DropDownList ID="ddlYear" runat="server" CssClass="date-select"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="mb-4">
                        <asp:Button ID="btnRegister" runat="server" Text="Registrar" CssClass="btn-primary w-full" OnClick="btnRegister_Click" />
                    </div>
                    <div class="text-center">
                        <asp:Label ID="lblErrorMessage" runat="server" CssClass="error-message" Visible="False"></asp:Label>
                    </div>
                    <div class="text-center mt-4">
                        <a href="Login.aspx" class="link">¿Ya tienes una cuenta? Inicia sesión</a>
                    </div>
                </div>
            </div>
        </main>
        
        <footer class="footer py-4 text-center">
            <p class="text-sm">© 2025 PoliMusic. Todos los derechos reservados.</p>
        </footer>
    </form>
</body>
</html>