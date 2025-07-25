using Microsoft.EntityFrameworkCore;
using MicroserviceSongControllerV5.Data;
using MicroserviceSongControllerV5.Repositories;

var builder = WebApplication.CreateBuilder(args);

// --- SECCIÓN DE CONFIGURACIÓN DE SERVICIOS ---

// 1. Agregar el DbContext al contenedor de inyección de dependencias.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

// 2. Registrar el repositorio para la inyección de dependencias.
// AddScoped significa que se creará una nueva instancia del repositorio por cada solicitud HTTP.
builder.Services.AddScoped<ISongRepository, SongRepository>();

// 3. Agregar servicios para controladores.
builder.Services.AddControllers();

// 4. Agregar servicios para la exploración de API y Swagger.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// --- SECCIÓN DE CONFIGURACIÓN DEL PIPELINE HTTP ---

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

// Mapea las rutas a los controladores.
app.MapControllers();

app.Run();