<%@ Page Title="Songs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV4.Song" Async="true"%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4 fade-in">
        <h2 class="text-center mb-4">🎶 Gestión de Canciones</h2>

        <!-- GridView 2: Canciones desde la Web API -->
        <h3 class="mb-3">🎧 Canciones desde Web API</h3>
        <asp:GridView ID="gridViewSong2" runat="server" CssClass="table table-bordered table-striped" />
        <hr class="my-4" />

        <!-- GridView 1: Canciones desde Servicio Web (SOAP) -->
        <h3 class="mb-3">📡 Canciones desde Servicio Web (SOAP)</h3>
        <asp:GridView ID="gridViewSong" runat="server" CssClass="table table-bordered table-striped" />
        <hr class="my-4" />

        <!-- GridView 1: Canciones desde DataSet del Servicio Web -->
        <h3 class="mb-3">📋 Canciones desde DataSet (SOAP)</h3>
        <asp:GridView ID="gridViewSong1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID_SONG"
            CssClass="table table-bordered table-hover table-striped">
            <Columns>
                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <asp:Label ID="lblId" runat="server" Text='<%# Bind("ID_SONG") %>' CssClass="text-muted" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Nombre de la Canción">
                    <ItemTemplate>
                        <asp:Label ID="lblName" runat="server" Text='<%# Bind("SONG_NAME") %>' CssClass="fw-semibold" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Reproducir">
                    <ItemTemplate>
                        <audio controls src='<%# Eval("SONG_PATH") %>'>
                            Tu navegador no soporta el elemento <code>audio</code>.
                        </audio>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
