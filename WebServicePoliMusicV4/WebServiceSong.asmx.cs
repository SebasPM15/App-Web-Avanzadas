using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebServicePoliMusicV4.Entities;

namespace WebServicePoliMusicV4
{
    /// <summary>
    /// Descripción breve de WebServiceSong
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
    // [System.Web.Script.Services.ScriptService]
    public class WebServiceSong : System.Web.Services.WebService
    {
        [WebMethod]
        public DataSet ReadDataSet()
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM TBL_SONG", conn))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        [WebMethod]
        public List<Song> Read()
        {
            List<Song> songs = new List<Song>();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM TBL_SONG", conn);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Song song = new Song();
                    song.Id = reader.GetInt32(0);
                    song.Name = reader.GetString(1);
                    song.Path = reader.GetString(2);
                    song.Plays = reader.GetInt32(3);
                    songs.Add(song);
                }
                reader.Close();
            }
            return songs;
        }
        [WebMethod]
        public int Create(string name, string path)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("INSERT INTO TBL_SONG (SONG_NAME, SONG_PATH) VALUES (@SONG_NAME, @SONG_PATH)", conn);
                cmd.Parameters.AddWithValue("@SONG_NAME", name);
                cmd.Parameters.AddWithValue("@SONG_PATH", path);
                int rowsAffected = cmd.ExecuteNonQuery();
                return rowsAffected;
            }
        }
        [WebMethod]
        public int Update(int idSong, string name, string path)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE TBL_SONG SET SONG_NAME = @SONG_NAME, SONG_PATH = @SONG_PATH WHERE ID_SONG = @ID_SONG", conn);
                cmd.Parameters.AddWithValue("@ID_SONG", idSong);
                cmd.Parameters.AddWithValue("@SONG_NAME", name);
                cmd.Parameters.AddWithValue("@SONG_PATH", path);
                int rowsAffected = cmd.ExecuteNonQuery();
                return rowsAffected;
            }
        }
        [WebMethod]
        public int Delete(int idSong)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM TBL_SONG WHERE ID_SONG = @ID_SONG", conn);
                cmd.Parameters.AddWithValue("@ID_SONG", idSong);
                int rowsAffected = cmd.ExecuteNonQuery();
                return rowsAffected;
            }
        }

    }

}
