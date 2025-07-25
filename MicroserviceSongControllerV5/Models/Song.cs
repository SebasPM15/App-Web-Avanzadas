using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MicroserviceSongControllerV5.Models
{
    // Mapea esta clase a la tabla TBL_SONG en la base de datos.
    [Table("TBL_SONG")]
    public class Song
    {
        // Define la propiedad ID_SONG como la clave primaria.
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("ID_SONG")]
        public int IdSong { get; set; }

        // Mapea esta propiedad a la columna SONG_NAME.
        [Required]
        [StringLength(50)]
        [Column("SONG_NAME")]
        public string SongName { get; set; } = string.Empty;

        // Mapea esta propiedad a la columna SONG_PATH.
        [Required]
        [StringLength(255)]
        [Column("SONG_PATH")]
        public string SongPath { get; set; } = string.Empty;

        // Mapea esta propiedad a la columna PLAYS.
        [Column("PLAYS")]
        public int? Plays { get; set; }
    }
}