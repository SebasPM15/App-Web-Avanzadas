using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApiPoliMusicRestXMLV4.Models
{
    public class Song
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Path { get; set; }
        public int? Plays { get; set; }
    }
}