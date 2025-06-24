<%@ Language=VBScript %>
<%
' Verificar si el usuario está autenticado
If Session("username") = "" Then
    Response.Redirect("login.asp")
End If

' Definir las variables de conexión
Dim conn, connString, rs, sql

' Establecer conexión con la base de datos SQL Server
connString = "Provider=SQLOLEDB;Data Source=localhost;Initial Catalog=BDD_PoliMusic_GR2;User ID=usr_polimusic_gr2;Password=Politecnica1;"
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open connString

' Consulta para obtener las canciones
sql = "SELECT [ID_SONG], [SONG_NAME], [SONG_PATH], [PLAYS] FROM [BDD_PoliMusic_GR2].[dbo].[TBL_SONG]"
Set rs = conn.Execute(sql)

' Array con las rutas de las canciones
Dim songFiles(4)
songFiles(0) = "SongFiles/bensound-adventure.mp3"
songFiles(1) = "SongFiles/bensound-dreams.mp3"
songFiles(2) = "SongFiles/bensound-energy.mp3"
songFiles(3) = "SongFiles/bensound-scifi.mp3"
songFiles(4) = "SongFiles/bensound-tomorrow.mp3"

%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Canciones - PoliMusic</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Custom styles */
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
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .animate-fade-in {
            animation: fadeIn 0.5s ease-out;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .progress-container {
                width: 150px;
            }
            
            th, td {
                padding: 0.75rem;
            }
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <header class="header py-4 px-6 flex items-center justify-between">
        <div class="flex items-center">
            <img src="Mateo_Logo.png" alt="Mateo P. Logo" class="h-10 w-auto mr-3">
            <h1 class="text-2xl font-bold">PoliMusic</h1>
        </div>
        <button class="btn-logout" onclick="window.location.href='logout.asp'">
            <i class="fas fa-sign-out-alt mr-2"></i>
            Cerrar sesión
        </button>
    </header>
    
    <main class="flex-grow container mx-auto px-4 py-8">
        <div class="animate-fade-in">
            <div class="text-center mb-8">
                <h2 class="welcome-text text-2xl font-semibold mb-2">Bienvenido, 
                    <span class="welcome-user"><%= Session("username") %></span>
                </h2>
                <p class="text-gray-600">Explora tu colección de canciones</p>
            </div>
            
            <div class="card p-6 mb-8">
                <div class="relative mb-6">
                    <i class="fas fa-search search-icon absolute top-1/2 transform -translate-y-1/2"></i>
                    <input type="text" id="searchInput" placeholder="Buscar canciones..." 
                           class="search-input w-full pl-10">
                </div>
                
                <div class="overflow-x-auto">
                    <table>
                        <thead>
                            <tr>
                                <th class="rounded-tl-lg">ID</th>
                                <th>Canción</th>
                                <th>Reproducciones</th>
                                <th class="rounded-tr-lg">Reproducir</th>
                            </tr>
                        </thead>
                        <tbody id="songTable">
                            <%
                            Dim counter, songIndex
                            counter = 0
                            
                            If Not rs.EOF Then
                                Do While Not rs.EOF
                                    ' Determinar qué canción local usar (ciclo cada 5 canciones)
                                    songIndex = counter Mod 5
                            %>
                            <tr data-song="<%= songFiles(songIndex) %>">
                                <td><%= rs("ID_SONG") %></td>
                                <td>
                                    <div class="flex items-center">
                                        <div class="song-cover mr-3">
                                            <i class="fas fa-music"></i>
                                        </div>
                                        <div><%= rs("SONG_NAME") %></div>
                                    </div>
                                </td>
                                <td><%= rs("PLAYS") %></td>
                                <td>
                                    <div class="flex items-center">
                                        <button class="play-btn mr-4" data-audio="audio-<%= counter %>">
                                            <i class="fas fa-play"></i>
                                        </button>
                                        <div class="player-controls">
                                            <div class="progress-container">
                                                <div class="progress-bar" id="progress-<%= counter %>"></div>
                                            </div>
                                            <div class="time-display">
                                                <span id="current-time-<%= counter %>">0:00</span>
                                                <span id="duration-<%= counter %>">0:00</span>
                                            </div>
                                        </div>
                                        <audio id="audio-<%= counter %>" data-id="<%= counter %>">
                                            <source src="<%= songFiles(songIndex) %>" type="audio/mpeg">
                                        </audio>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    counter = counter + 1
                                    rs.MoveNext
                                Loop
                            Else
                            %>
                            <tr>
                                <td colspan="4" class="no-songs">
                                    <i class="fas fa-music no-songs-icon"></i>
                                    <p>No se encontraron canciones.</p>
                                </td>
                            </tr>
                            <%
                            End If
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
    
    <footer class="footer py-4 text-center">
        <p class="text-sm">© 2025 PoliMusic. Todos los derechos reservados.</p>
    </footer>
    
    <% 
    ' Cerrar la conexión a la base de datos
    rs.Close
    conn.Close
    Set rs = Nothing
    Set conn = Nothing
    %>
    
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
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
            button.addEventListener('click', function() {
                const audioId = this.getAttribute('data-audio');
                const audio = document.getElementById(audioId);
                const progressBar = document.getElementById('progress-' + audio.dataset.id);
                const currentTimeDisplay = document.getElementById('current-time-' + audio.dataset.id);
                const durationDisplay = document.getElementById('duration-' + audio.dataset.id);
                
                // Pause current audio if different
                if (currentAudio && currentAudio !== audio) {
                    currentAudio.pause();
                    if (currentButton) {
                        currentButton.innerHTML = '<i class="fas fa-play"></i>';
                        currentButton.classList.remove('playing');
                    }
                }
                
                if (audio.paused) {
                    audio.play();
                    this.innerHTML = '<i class="fas fa-pause"></i>';
                    this.classList.add('playing');
                    currentAudio = audio;
                    currentButton = this;
                    
                    // Update duration display
                    audio.addEventListener('loadedmetadata', function() {
                        const duration = audio.duration;
                        durationDisplay.textContent = formatTime(duration);
                    });
                    
                    // Update progress bar
                    audio.addEventListener('timeupdate', function() {
                        const currentTime = audio.currentTime;
                        const duration = audio.duration;
                        const progressPercent = (currentTime / duration) * 100;
                        progressBar.style.width = progressPercent + '%';
                        currentTimeDisplay.textContent = formatTime(currentTime);
                    });
                    
                    // Reset when finished
                    audio.addEventListener('ended', function() {
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
            container.addEventListener('click', function(e) {
                const rect = this.getBoundingClientRect();
                const clickPosition = (e.clientX - rect.left) / rect.width;
                const audioId = this.parentElement.parentElement.querySelector('audio').id;
                const audio = document.getElementById(audioId);
                const newTime = clickPosition * audio.duration;
                audio.currentTime = newTime;
            });
        });
    </script>
</body>
</html>