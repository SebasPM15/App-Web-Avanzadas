using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
    }
}