using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace WebAppPoliMusicV4
{
    public partial class Song : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindData();
                BindDataSet();
                LoadSongs();
            }
        }
        private void BindData()
        {
            ServiceReferenceSong.Song[] songs = new ServiceReferenceSong.WebServiceSongSoapClient().Read();
            if (songs != null && songs.Length > 0)
            {
                gridViewSong.DataSource = songs;
                gridViewSong.DataBind();
            }
        }
        private void BindDataSet()
        {
            DataTable dtSong = new ServiceReferenceSong.WebServiceSongSoapClient().ReadDataSet().Tables[0];
            if (dtSong != null && dtSong.Rows.Count > 0)
            {
                gridViewSong1.DataSource = dtSong;
                gridViewSong1.DataBind();
            }
        }
        private async void LoadSongs()
        {
            string apiUrl = "http://localhost:51782/api/songs"; // <-- Cambia xxxx al puerto tuyo

            using (HttpClient client = new HttpClient())
            {
                try
                {
                    HttpResponseMessage response = await client.GetAsync(apiUrl);
                    response.EnsureSuccessStatusCode();

                    string json = await response.Content.ReadAsStringAsync();
                    var songs = JsonConvert.DeserializeObject<List<SongModel>>(json);

                    gridViewSong2.DataSource = songs;
                    gridViewSong2.DataBind();
                }
                catch (Exception ex)
                {
                    // Log or handle error
                    Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                }
            }
        }
        public class SongModel
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Path { get; set; }
            public int? Plays { get; set; }
        }
    }
}