using Microsoft.EntityFrameworkCore;
using MicroserviceSongControllerV5.Data;
using MicroserviceSongControllerV5.Models;

namespace MicroserviceSongControllerV5.Repositories
{
    // Implementación del repositorio de canciones.
    public class SongRepository : ISongRepository
    {
        private readonly AppDbContext _context;

        public SongRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Song>> GetAllAsync()
        {
            return await _context.Songs.ToListAsync();
        }

        public async Task<Song?> GetByIdAsync(int id)
        {
            return await _context.Songs.FindAsync(id);
        }

        public async Task AddAsync(Song song)
        {
            await _context.Songs.AddAsync(song);
            await _context.SaveChangesAsync();
        }

        // --- CORRECCIÓN ---
        // El método ahora asume que la entidad ya está siendo rastreada y ha sido modificada.
        // Su única responsabilidad es persistir esos cambios en la base de datos.
        public async Task UpdateAsync(Song song)
        {
            // Simplemente guardamos los cambios. No es necesario cambiar el estado de la entidad aquí.
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var songToDelete = await _context.Songs.FindAsync(id);
            if (songToDelete != null)
            {
                _context.Songs.Remove(songToDelete);
                await _context.SaveChangesAsync();
            }
        }
    }
}