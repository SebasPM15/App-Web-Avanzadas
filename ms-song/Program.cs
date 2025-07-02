var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/api/songs", async () => await GetAllSongsAsync(connectionString));
//app.MapGet("/api/songs", () => GetAllSongs(connectionString));

app.MapGet("/api/songsexample", () => GetAllSongsArray())
.WithName("GetAllSongs")
.WithOpenApi();

app.Run();

static async Task<IEnumerable<Song>> GetAllSongsAsync(string? connectionString)
{
    using (Microsoft.Data.SqlClient.SqlConnection connection = new(connectionString))
    {
        using (Microsoft.Data.SqlClient.SqlCommand command = new("SELECT * FROM TBL_SONG", connection))
        {
            var songs = new List<Song>();
            await connection.OpenAsync();
            using (Microsoft.Data.SqlClient.SqlDataReader reader = await command.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    songs.Add(new Song
                    {
                        Id = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Path = reader.GetString(2)
                    });
                }
                return songs;
            }
        }
    }
}
static IEnumerable<Song> GetAllSongs(string? connectionString)
{
    using (Microsoft.Data.SqlClient.SqlConnection connection = new(connectionString))
    {
        using (Microsoft.Data.SqlClient.SqlCommand command = new("SELECT * FROM TBL_SONG", connection))
        {
            connection.Open();
            using (Microsoft.Data.SqlClient.SqlDataReader reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    yield return new Song
                    {
                        Id = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Path = reader.GetString(2)
                    };
                }
            }
        }
    }
}

static IEnumerable<Song> GetAllSongsArray()
{
    return new List<Song>
    {
        new() { Id = 1, Name = "Mateo Pilco", Path = "Path 1" },
        new() { Id = 2, Name = "Song 2", Path = "Path 2" },
        new() { Id = 3, Name = "Song 3", Path = "Path 3" }
    };
}
public record Song
{
    public int Id { get; init; }
    public string? Name { get; init; }
    public string? Path { get; init; }
}
