using Microsoft.AspNetCore.Mvc;
using MicroserviceSongControllerV5.Models;
using MicroserviceSongControllerV5.Repositories;

namespace MicroserviceSongControllerV5.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SongsController : ControllerBase
    {
        private readonly ISongRepository _songRepository;

        public SongsController(ISongRepository songRepository)
        {
            _songRepository = songRepository;
        }

        // GET: api/songs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Song>>> GetSongs()
        {
            var songs = await _songRepository.GetAllAsync();
            return Ok(songs);
        }

        // GET: api/songs/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Song>> GetSong(int id)
        {
            var song = await _songRepository.GetByIdAsync(id);
            if (song == null)
            {
                return NotFound();
            }
            return Ok(song);
        }

        // POST: api/songs
        [HttpPost]
        public async Task<ActionResult<Song>> PostSong(Song song)
        {
            await _songRepository.AddAsync(song);
            return CreatedAtAction(nameof(GetSong), new { id = song.IdSong }, song);
        }

        // --- CORRECCIÓN ---
        // PUT: api/songs/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSong(int id, Song inputSong)
        {
            if (id != inputSong.IdSong)
            {
                return BadRequest("El ID de la URL no coincide con el ID del cuerpo de la solicitud.");
            }

            // 1. Obtenemos la entidad existente de la base de datos. EF Core comienza a rastrearla.
            var songToUpdate = await _songRepository.GetByIdAsync(id);
            if (songToUpdate == null)
            {
                return NotFound(); // No se encontró la canción para actualizar.
            }

            // 2. Actualizamos las propiedades de la entidad que YA está siendo rastreada.
            songToUpdate.SongName = inputSong.SongName;
            songToUpdate.SongPath = inputSong.SongPath;
            songToUpdate.Plays = inputSong.Plays;

            // 3. Llamamos al repositorio para que guarde los cambios en la entidad rastreada.
            await _songRepository.UpdateAsync(songToUpdate);

            return NoContent();
        }

        // DELETE: api/songs/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSong(int id)
        {
            var song = await _songRepository.GetByIdAsync(id);
            if (song == null)
            {
                return NotFound();
            }
            await _songRepository.DeleteAsync(id);
            return NoContent();
        }
    }
}