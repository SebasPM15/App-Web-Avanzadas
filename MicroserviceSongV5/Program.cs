using Microsoft.EntityFrameworkCore;
using MicroserviceSongV5.Data;
using MicroserviceSongV5.Models;

var builder = WebApplication.CreateBuilder(args);

// --- SECCIÓN DE CONFIGURACIÓN DE SERVICIOS ---

// 1. Agregar el DbContext al contenedor de inyección de dependencias.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

// 2. Agregar servicios para la exploración de API y Swagger (útil para pruebas).
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// --- SECCIÓN DE CONFIGURACIÓN DEL PIPELINE HTTP ---

// Configurar el pipeline de solicitud HTTP.
// Habilitar Swagger solo en el entorno de desarrollo.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// --- SECCIÓN DE DEFINICIÓN DE ENDPOINTS ---

// Agrupar los endpoints de la API bajo el prefijo "/api/songs".
var api = app.MapGroup("/api/songs");

// Endpoint para OBTENER todas las canciones (GET /api/songs)
api.MapGet("/", async (AppDbContext db) =>
{
    // Busca todas las canciones en la base de datos y las devuelve.
    var songs = await db.Songs.ToListAsync();
    return Results.Ok(songs);
});

// Endpoint para OBTENER una canción por su ID (GET /api/songs/{id})
api.MapGet("/{id:int}", async (int id, AppDbContext db) =>
{
    // Busca una canción por su ID. Si la encuentra, la devuelve.
    // Si no, devuelve un resultado 404 Not Found.
    var song = await db.Songs.FindAsync(id);
    return song is not null ? Results.Ok(song) : Results.NotFound();
});

// Endpoint para CREAR una nueva canción (POST /api/songs)
api.MapPost("/", async (Song song, AppDbContext db) =>
{
    // Agrega la nueva canción al contexto de la base de datos.
    db.Songs.Add(song);
    // Guarda los cambios en la base de datos.
    await db.SaveChangesAsync();
    // Devuelve una respuesta 201 Created con la ubicación y el objeto creado.
    return Results.Created($"/api/songs/{song.IdSong}", song);
});

// Endpoint para ACTUALIZAR una canción existente (PUT /api/songs/{id})
api.MapPut("/{id:int}", async (int id, Song inputSong, AppDbContext db) =>
{
    // Busca la canción que se va a actualizar.
    var song = await db.Songs.FindAsync(id);

    if (song is null)
    {
        // Si no se encuentra la canción, devuelve 404 Not Found.
        return Results.NotFound();
    }

    // Actualiza las propiedades de la canción encontrada con los valores de entrada.
    song.SongName = inputSong.SongName;
    song.SongPath = inputSong.SongPath;
    song.Plays = inputSong.Plays;

    // Guarda los cambios en la base de datos.
    await db.SaveChangesAsync();
    
    // Devuelve una respuesta 204 No Content para indicar que la actualización fue exitosa.
    return Results.NoContent();
});

// Endpoint para ELIMINAR una canción (DELETE /api/songs/{id})
api.MapDelete("/{id:int}", async (int id, AppDbContext db) =>
{
    // Busca la canción por su ID.
    var song = await db.Songs.FindAsync(id);

    if (song is null)
    {
        // Si no se encuentra, devuelve 404 Not Found.
        return Results.NotFound();
    }

    // Elimina la canción del contexto.
    db.Songs.Remove(song);
    // Aplica los cambios en la base de datos.
    await db.SaveChangesAsync();

    // Devuelve una respuesta 204 No Content.
    return Results.NoContent();
});


app.Run();