using Microsoft.EntityFrameworkCore;
using MicroserviceSongV5.Models;

namespace MicroserviceSongV5.Data
{
    // DbContext es la clase principal de Entity Framework Core para interactuar con la base de datos.
    public class AppDbContext : DbContext
    {
        // El constructor recibe las opciones de configuración del DbContext,
        // como la cadena de conexión, que se inyectarán desde Program.cs.
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        // DbSet representa una colección de entidades (en este caso, canciones)
        // que se pueden consultar desde la base de datos.
        // Corresponde a la tabla TBL_SONG.
        public DbSet<Song> Songs { get; set; }
    }
}
