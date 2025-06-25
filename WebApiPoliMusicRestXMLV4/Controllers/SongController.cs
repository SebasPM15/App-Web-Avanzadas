using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebApiPoliMusicRestXMLV4.Models;
using WebApiPoliMusicRestXMLV4.Repositories;

namespace WebApiPoliMusicRestXMLV4.Controllers
{
    public class SongsController : ApiController
    {
        private readonly SongRepository songRepository;

        public SongsController()
        {
            this.songRepository = new SongRepository();
        }

        // GET api/songs
        public IEnumerable<Song> Get()
        {
            return songRepository.GetSongs();
        }

        // GET api/songs/{id}
        public IHttpActionResult Get(int id)
        {
            Song song = songRepository.GetSongById(id);
            if (song == null)
            {
                return NotFound();
            }
            return Ok(song);
        }

        // POST api/songs
        public IHttpActionResult Post([FromBody] Song song)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            int newId = songRepository.AddSong(song);
            song.Id = newId; // Optionally update the song object with the new ID

            // Return Created status code and the created entity
            return CreatedAtRoute("DefaultApi", new { id = song.Id }, song);
        }

        // PUT api/songs/{id}
        public IHttpActionResult Put(int id, [FromBody] Song song)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != song.Id)
            {
                return BadRequest();
            }

            int rowsAffected = songRepository.UpdateSong(song);

            if (rowsAffected > 0)
            {
                return StatusCode(HttpStatusCode.NoContent);
            }
            else
            {
                return NotFound();
            }
        }

        // DELETE api/songs/{id}
        public IHttpActionResult Delete(int id)
        {
            int rowsAffected = songRepository.DeleteSong(id);

            if (rowsAffected > 0)
            {
                return Ok();
            }
            else
            {
                return NotFound();
            }
        }
    }

}
