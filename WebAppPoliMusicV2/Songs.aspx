<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Songs.aspx.cs" Inherits="WebAppPoliMusicV2.Songs" %>

<!DOCTYPE html>

<html lang="es" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Canciones - PoliMusic</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            background-color: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh; /* Asegura que ocupe toda la altura de la pantalla */
        }
        .header {
            background-color: #222222;
            color: #FFFFFF;
        }
        .footer {
            background-color: #222222;
            color: #FFFFFF;
            margin-top: auto; /* Empuja el footer al final */
        }
        .card {
            background-color: #FFFFFF;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
        }
        .btn-logout {
            background-color: #E13227;
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-logout:hover {
            background-color: #C12A20;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(225, 50, 39, 0.3);
        }
        .welcome-text {
            color: #333333;
        }
        .welcome-user {
            color: #E13227;
            font-weight: bold;
        }
        .search-input {
            padding: 0.75rem 1rem 0.75rem 3rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background-color: #FFFFFF;
            color: #333333;
            transition: all 0.3s ease;
        }
        .search-input:focus {
            border-color: #E13227;
            box-shadow: 0 0 0 3px rgba(225, 50, 39, 0.2);
            outline: none;
        }
        .search-icon {
            left: 1rem;
            color: #777777;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background-color: #222222;
            color: #FFFFFF;
            padding: 1rem;
            text-align: left;
        }
        td {
            padding: 1rem;
            border-bottom: 1px solid #e0e0e0;
            color: #333333;
        }
        tr:hover {
            background-color: rgba(225, 50, 39, 0.05);
        }
        .song-cover {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background-color: #E13227;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .play-btn {
            background-color: #E13227;
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .play-btn:hover {
            background-color: #C12A20;
            transform: scale(1.05);
        }
        .play-btn.playing {
            background-color: #333333;
        }
        .progress-container {
            width: 200px;
            height: 4px;
            background-color: #e0e0e0;
            border-radius: 2px;
            margin-top: 8px;
            overflow: hidden;
        }
        .progress-bar {
            height: 100%;
            background-color: #E13227;
            width: 0%;
            transition: width 0.1s linear;
        }
        .time-display {
            font-size: 0.75rem;
            color: #777777;
            margin-top: 4px;
            display: flex;
            justify-content: space-between;
        }
        .no-songs {
            text-align: center;
            padding: 2rem;
            color: #777777;
        }
        .no-songs-icon {
            font-size: 2.5rem;
            color: #e0e0e0;
            margin-bottom: 1rem;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        @media (max-width: 768px) {
            .progress-container {
                width: 150px;
            }
            th, td {
                padding: 0.75rem;
            }
        }
        .sortable {
            cursor: pointer;
        }
        .sortable:hover {
            background-color: #333333;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <form id="form1" runat="server">
        <header class="header py-4 px-6 flex items-center justify-between">
            <div class="flex items-center">
                <img src="Mateo_Logo.png" alt="Mateo P. Logo" class="h-10 w-auto mr-3" />
                <h1 class="text-2xl font-bold">PoliMusic</h1>
            </div>
            <asp:LinkButton ID="linkButtonCloseSession" runat="server" CssClass="btn-logout" PostBackUrl="~/Logout.aspx">
                <i class="fas fa-sign-out-alt mr-2"></i>Cerrar sesión
            </asp:LinkButton>
        </header>
        
        <main class="flex-grow container mx-auto px-4 py-8">
            <div class="animate-fade-in">
                <div class="text-center mb-8">
                    <h2 class="welcome-text text-2xl font-semibold mb-2">Bienvenido, 
                        <asp:Label ID="lblUserName" runat="server" CssClass="welcome-user"></asp:Label>
                    </h2>
                    <p class="text-gray-600">Explora tu colección de canciones</p>
                </div>
                
                <div class="card p-6 mb-8">
                    <div class="relative mb-6">
                        <i class="fas fa-search search-icon absolute top-1/2 transform -translate-y-1/2"></i>
                        <input type="text" id="searchInput" placeholder="Buscar canciones..." 
                               class="search-input w-full pl-10" />
                    </div>
                    
                    <div class="overflow-x-auto">
                        <table>
                            <thead>
                                <tr>
                                    <th class="sortable rounded-tl-lg">
                                        <asp:LinkButton ID="lnkSortId" runat="server" CommandArgument="ID_SONG" OnClick="SortSongs">ID</asp:LinkButton>
                                    </th>
                                    <th class="sortable">
                                        <asp:LinkButton ID="lnkSortName" runat="server" CommandArgument="SONG_NAME" OnClick="SortSongs">Canción</asp:LinkButton>
                                    </th>
                                    <th class="sortable">
                                        <asp:LinkButton ID="lnkSortPlays" runat="server" CommandArgument="PLAYS" OnClick="SortSongs">Reproducciones</asp:LinkButton>
                                    </th>
                                    <th class="rounded-tr-lg">Reproducir</th>
                                </tr>
                            </thead>
                            <tbody id="songTable">
                                <asp:Repeater ID="rptSongs" runat="server">
                                    <ItemTemplate>
                                        <tr data-song='<%# Eval("SongFile") %>'>
                                            <td><%# Eval("ID_SONG") %></td>
                                            <td>
                                                <div class="flex items-center">
                                                    <div class="song-cover mr-3">
                                                        <i class="fas fa-music"></i>
                                                    </div>
                                                    <div><%# Eval("SONG_NAME") %></div>
                                                </div>
                                            </td>
                                            <td><%# Eval("PLAYS") %></td>
                                            <td>
                                                <div class="flex items-center">
                                                    <button class="play-btn mr-4" data-audio='<%# "audio-" + Eval("RowIndex") %>'>
                                                        <i class="fas fa-play"></i>
                                                    </button>
                                                    <div class="player-controls">
                                                        <div class="progress-container">
                                                            <div class="progress-bar" id='<%# "progress-" + Eval("RowIndex") %>'></div>
                                                        </div>
                                                        <div class="time-display">
                                                            <span id='<%# "current-time-" + Eval("RowIndex") %>'>0:00</span>
                                                            <span id='<%# "duration-" + Eval("RowIndex") %>'>0:00</span>
                                                        </div>
                                                    </div>
                                                    <audio id='<%# "audio-" + Eval("RowIndex") %>' data-id='<%# Eval("RowIndex") %>'>
                                                        <source src='<%# ResolveUrl("~/SongFiles/" + Eval("SongFile")) %>' type="audio/mpeg" />
                                                    </audio>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <% if (rptSongs.Items.Count == 0) { %>
                                            <tr>
                                                <td colspan="4" class="no-songs">
                                                    <i class="fas fa-music no-songs-icon"></i>
                                                    <p>No se encontraron canciones.</p>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
        
        <footer class="footer py-4 text-center">
            <p class="text-sm">© 2025 PoliMusic. Todos los derechos reservados.</p>
        </footer>
    </form>
    
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('#songTable tr');

            rows.forEach(row => {
                if (row.querySelector('.no-songs')) return;

                const songName = row.cells[1].textContent.toLowerCase();
                row.style.display = songName.includes(searchTerm) ? '' : 'none';
            });
        });

        // Audio player functionality
        let currentAudio = null;
        let currentButton = null;

        document.querySelectorAll('.play-btn').forEach(button => {
            button.addEventListener('click', function () {
                const audioId = this.getAttribute('data-audio');
                const audio = document.getElementById(audioId);
                const progressBar = document.getElementById('progress-' + audio.dataset.id);
                const currentTimeDisplay = document.getElementById('current-time-' + audio.dataset.id);
                const durationDisplay = document.getElementById('duration-' + audio.dataset.id);

                if (!audio) {
                    console.error('Audio element not found for ID:', audioId);
                    return;
                }

                // Pause current audio if different
                if (currentAudio && currentAudio !== audio) {
                    currentAudio.pause();
                    if (currentButton) {
                        currentButton.innerHTML = '<i class="fas fa-play"></i>';
                        currentButton.classList.remove('playing');
                    }
                }

                if (audio.paused) {
                    audio.play().catch(error => {
                        console.error('Error playing audio:', error);
                    });
                    this.innerHTML = '<i class="fas fa-pause"></i>';
                    this.classList.add('playing');
                    currentAudio = audio;
                    currentButton = this;

                    // Update duration display
                    audio.addEventListener('loadedmetadata', function () {
                        const duration = audio.duration || 0;
                        durationDisplay.textContent = formatTime(duration);
                    });

                    // Update progress bar
                    audio.addEventListener('timeupdate', function () {
                        const currentTime = audio.currentTime || 0;
                        const duration = audio.duration || 0;
                        const progressPercent = (currentTime / duration) * 100 || 0;
                        progressBar.style.width = progressPercent + '%';
                        currentTimeDisplay.textContent = formatTime(currentTime);
                    });

                    // Reset when finished
                    audio.addEventListener('ended', function () {
                        this.currentTime = 0;
                        progressBar.style.width = '0%';
                        currentTimeDisplay.textContent = '0:00';
                        button.innerHTML = '<i class="fas fa-play"></i>';
                        button.classList.remove('playing');
                    });
                } else {
                    audio.pause();
                    this.innerHTML = '<i class="fas fa-play"></i>';
                    this.classList.remove('playing');
                }
            });
        });

        // Format time (seconds to MM:SS)
        function formatTime(seconds) {
            const minutes = Math.floor(seconds / 60);
            const secs = Math.floor(seconds % 60);
            return `${minutes}:${secs < 10 ? '0' : ''}${secs}`;
        }

        // Click on progress bar to seek
        document.querySelectorAll('.progress-container').forEach(container => {
            container.addEventListener('click', function (e) {
                const rect = this.getBoundingClientRect();
                const clickPosition = (e.clientX - rect.left) / rect.width;
                const audioId = this.parentElement.parentElement.querySelector('audio').id;
                const audio = document.getElementById(audioId);
                if (audio) {
                    const newTime = clickPosition * (audio.duration || 0);
                    audio.currentTime = newTime;
                }
            });
        });
    </script>
</body>
</html>