# Etapa 1: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

WORKDIR /src

# ✅ Copiar archivos de solución y proyectos
COPY *.sln ./
COPY ms-song/*.csproj ./ms-song/

# ✅ Restaurar dependencias
RUN dotnet restore ./ms-song/ms-song.csproj

# ✅ Copiar el resto del código fuente
COPY ms-song/ ./ms-song/

# ✅ Publicar la app
WORKDIR /src/ms-song
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/publish .

# Exponer el puerto que usas
EXPOSE 8080

# Ejecutar la app
ENTRYPOINT ["dotnet", "ms-song.dll"]
