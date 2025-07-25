using Microsoft.EntityFrameworkCore;
using MicroserviceSongControllerV5.Models;

namespace MicroserviceSongControllerV5.Data
{
    // DbContext para la interacción con la base de datos.
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        // DbSet que representa la tabla de canciones.
        public DbSet<Song> Songs { get; set; }
    }
}