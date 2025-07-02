<%@ WebHandler Language="C#" Class="SearchSongs" %>
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public class SearchSongs : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/html";
        string searchTerm = context.Request.QueryString["term"];
        string connectionString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT [ID_SONG], [SONG_NAME], [SONG_PATH], [PLAYS] FROM [TBL_SONG]";
            if (!string.IsNullOrEmpty(searchTerm))
            {
                query += " WHERE [SONG_NAME] LIKE @SearchTerm";
            }
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                }
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    System.Text.StringBuilder html = new System.Text.StringBuilder();
                    html.Append("<table class='table' id='<%= gvSongs.ClientID %>'><thead><tr><th>ID</th><th>Nombre</th><th>Reproducciones</th><th>Acción</th></tr></thead><tbody>");
                    foreach (DataRow row in dt.Rows)
                    {
                        html.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td><button type='button' class='btn' onclick=\"togglePlay('{3}')\"><i class='fas fa-play'></i> Reproducir</button></td></tr>",
                            row["ID_SONG"], row["SONG_NAME"], row["PLAYS"], row["SONG_PATH"]);
                    }
                    html.Append("</tbody></table>");
                    context.Response.Write(html.ToString());
                }
            }
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}