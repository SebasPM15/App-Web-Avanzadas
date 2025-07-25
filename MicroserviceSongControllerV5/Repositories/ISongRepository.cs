using MicroserviceSongControllerV5.Models;

namespace MicroserviceSongControllerV5.Repositories
{
    // Interfaz que define las operaciones CRUD para las canciones.
    // Usar una interfaz permite desacoplar el controlador de la implementación concreta del repositorio.
    public interface ISongRepository
    {
        Task<IEnumerable<Song>> GetAllAsync();
        Task<Song?> GetByIdAsync(int id);
        Task AddAsync(Song song);
        Task UpdateAsync(Song song);
        Task DeleteAsync(int id);
    }
}