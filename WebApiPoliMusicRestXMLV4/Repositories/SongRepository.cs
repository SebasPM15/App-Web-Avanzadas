using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebApiPoliMusicRestXMLV4.Models;

namespace WebApiPoliMusicRestXMLV4.Repositories
{
    public class SongRepository
    {
        private readonly string connectionString;

        public SongRepository()
        {
            // Retrieve connection string from configuration
            connectionString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;
        }

        public IEnumerable<Song> GetSongs()
        {
            List<Song> songs = new List<Song>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT [ID_SONG],[SONG_NAME],[SONG_PATH],[PLAYS] FROM [TBL_SONG]";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        Song song = new Song();
                        song.Id = Convert.ToInt32(reader["ID_SONG"]);
                        song.Name = Convert.ToString(reader["SONG_NAME"]);
                        song.Path = Convert.ToString(reader["SONG_PATH"]);
                        song.Plays = Convert.ToInt32(reader["PLAYS"]);
                        songs.Add(song);
                    }
                    reader.Close();
                }
            }
            return songs;
        }
        public Song GetSongById(int id)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string sql = "SELECT ID_SONG, SONG_NAME, SONG_PATH, PLAYS FROM TBL_SONG WHERE ID_SONG = @Id";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@Id", id);
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();

                if (reader.Read())
                {
                    Song song = new Song();
                    song.Id = Convert.ToInt32(reader["ID_SONG"]);
                    song.Name = reader["SONG_NAME"].ToString();
                    song.Path = reader["SONG_PATH"].ToString();
                    song.Plays = reader["PLAYS"] == DBNull.Value ? null : (int?)Convert.ToInt32(reader["PLAYS"]);
                    reader.Close();
                    return song;
                }
                else
                {
                    reader.Close();
                    return null;
                }
            }
        }

        public int AddSong(Song song)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string sql = "INSERT INTO TBL_SONG (SONG_NAME, SONG_PATH, PLAYS) VALUES (@SongName, @SongPath, @Plays)";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@SongName", song.Name);
                command.Parameters.AddWithValue("@SongPath", song.Path);
                command.Parameters.AddWithValue("@Plays", song.Plays ?? (object)DBNull.Value);
                connection.Open();
                return command.ExecuteNonQuery();
            }
        }

        public int UpdateSong(Song song)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string sql = "UPDATE TBL_SONG SET SONG_NAME = @SongName, SONG_PATH = @SongPath, PLAYS = @Plays WHERE ID_SONG = @Id";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@Id", song.Id);
                command.Parameters.AddWithValue("@SongName", song.Name);
                command.Parameters.AddWithValue("@SongPath", song.Path);
                command.Parameters.AddWithValue("@Plays", song.Plays ?? (object)DBNull.Value);
                connection.Open();
                return command.ExecuteNonQuery();
            }
        }

        public int DeleteSong(int id)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string sql = "DELETE FROM TBL_SONG WHERE ID_SONG = @Id";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@Id", id);
                connection.Open();
                return command.ExecuteNonQuery();
            }
        }
    }
}