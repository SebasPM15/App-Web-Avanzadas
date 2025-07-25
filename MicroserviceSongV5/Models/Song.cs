using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MicroserviceSongV5.Models
{
    // Mapea esta clase a la tabla TBL_SONG en la base de datos.
    [Table("TBL_SONG")]
    public class Song
    {
        // Define la propiedad ID_SONG como la clave primaria.
        [Key]
        // Especifica que el valor de esta propiedad es generado por la base de datos (Identity).
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("ID_SONG")]
        public int IdSong { get; set; }

        // Mapea esta propiedad a la columna SONG_NAME.
        // Es un campo requerido y tiene una longitud máxima de 50 caracteres.
        [Required]
        [StringLength(50)]
        [Column("SONG_NAME")]
        public string SongName { get; set; } = string.Empty;

        // Mapea esta propiedad a la columna SONG_PATH.
        // Es un campo requerido con una longitud máxima de 255.
        [Required]
        [StringLength(255)]
        [Column("SONG_PATH")]
        public string SongPath { get; set; } = string.Empty;

        // Mapea esta propiedad a la columna PLAYS.
        // Es un campo opcional (puede ser nulo).
        [Column("PLAYS")]
        public int? Plays { get; set; }
    }
}
