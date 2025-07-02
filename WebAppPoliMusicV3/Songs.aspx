<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Songs.aspx.cs" Inherits="WebAppPoliMusicV3.Songs" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Canciones - PoliMusic</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Animate.css CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
        .btn {
            background-color: #E13227;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
            text-align: center;
            display: inline-block;
        }
        .btn:hover {
            background-color: #C12A20;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(225, 50, 39, 0.3);
        }
        .btn:active {
            transform: translateY(0);
        }
        .btn::after {
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
        .btn:hover::after {
            transform: translateX(0);
        }
        .header {
            background-color: #222222;
            color: #FFFFFF;
        }
        .footer {
            background-color: #222222;
            color: #FFFFFF;
        }
        .text-primary {
            color: #333333;
        }
        .text-secondary {
            color: #777777;
        }
        .text-accent {
            color: #E13227;
        }
        .link-hover:hover {
            color: #C12A20;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .table th, .table td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        .table th {
            background-color: #f9f9f9;
            font-weight: 600;
        }
        .table tr:hover {
            background-color: #f1f1f1;
        }
        .audio-player {
            margin-top: 1rem;
            width: 100%;
            max-width: 400px;
            display: block;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <header class="header py-6 px-6 flex items-center justify-between">
        <div class="flex items-center">
            <img src="Mateo_Logo.png" alt="Mateo P. Logo" class="h-12 w-auto mr-4">
            <h1 class="text-3xl font-bold text-white">PoliMusic</h1>
        </div>
        <div class="flex items-center">
            <span class="text-white mr-4"><asp:Literal ID="litUsername" runat="server"></asp:Literal></span>
            <asp:HyperLink ID="lnkLogOut" runat="server" NavigateUrl="~/LogOut.aspx" CssClass="text-sm text-white hover:text-accent link-hover">Cerrar Sesión</asp:HyperLink>
        </div>
    </header>

    <main class="flex-grow px-4 py-12">
        <form id="form1" runat="server">
            <div class="card p-10 w-full max-w-4xl mx-auto animate__animated animate__fadeIn">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-3xl font-bold text-primary">Canciones</h2>
                    <div class="input-group w-64">
                        <i class="fas fa-search input-icon"></i>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="input-field" placeholder="Buscar canciones..."></asp:TextBox>
                    </div>
                </div>
                <asp:GridView ID="gvSongs" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ID_SONG" HeaderText="ID" />
                        <asp:BoundField DataField="SONG_NAME" HeaderText="Nombre" />
                        <asp:BoundField DataField="PLAYS" HeaderText="Reproducciones" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <button type="button" class="btn" onclick="togglePlay('<%# Eval("SONG_PATH") %>')">
                                    <i class="fas fa-play"></i> Reproducir
                                </button>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <audio id="audioPlayer" class="audio-player" controls></audio>
                <div class="mt-6">
                    <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Default.aspx" CssClass="btn">Volver al Inicio</asp:HyperLink>
                </div>
            </div>
        </form>
    </main>

    <footer class="footer py-4 text-center text-sm">
        <p>© 2025 PoliMusic. Todos los derechos reservados.</p>
    </footer>

    <script>
        // Live search functionality
        const txtSearch = document.getElementById('<%= txtSearch.ClientID %>');
        const gvSongs = document.getElementById('<%= gvSongs.ClientID %>');
        txtSearch.addEventListener('input', function () {
            const searchTerm = this.value;
            if (searchTerm.length > 2) { // Trigger search after 3 characters
                fetch('/SearchSongs.ashx?term=' + encodeURIComponent(searchTerm))
                    .then(response => response.text())
                    .then(html => {
                        gvSongs.innerHTML = html;
                    })
                    .catch(error => console.error('Error:', error));
            } else if (searchTerm.length === 0) {
                fetch('/SearchSongs.ashx')
                    .then(response => response.text())
                    .then(html => {
                        gvSongs.innerHTML = html;
                    })
                    .catch(error => console.error('Error:', error));
            }
        });

        // Audio player controls
        let isPlaying = false;
        function togglePlay(songPath) {
            const audioPlayer = document.getElementById('audioPlayer');
            if (!isPlaying || audioPlayer.src !== songPath) {
                audioPlayer.src = songPath;
                audioPlayer.play();
                isPlaying = true;
            } else {
                if (audioPlayer.paused) {
                    audioPlayer.play();
                } else {
                    audioPlayer.pause();
                }
            }
        }

        // Update play/pause state
        const audioPlayer = document.getElementById('audioPlayer');
        audioPlayer.addEventListener('play', () => isPlaying = true);
        audioPlayer.addEventListener('pause', () => isPlaying = false);
        audioPlayer.addEventListener('ended', () => isPlaying = false);
    </script>
</body>
</html>