# slika, ki jo uporabimo za zagon aplikacije
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080

# slika, ki jo uporabimo za izgradnjo
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
# najprej kopiramo samo .csproj in obnovimo odvisnosti
COPY ["TurnirManager/TurnirManager.csproj", "TurnirManager/"]
RUN dotnet restore "TurnirManager/TurnirManager.csproj"
# nato kopiramo še ostalo kodo in zgradimo projekt
COPY . .
WORKDIR "/src/TurnirManager"
RUN dotnet build "TurnirManager.csproj" -c Release -o /app/build

# objava projekta
FROM build AS publish
RUN dotnet publish "TurnirManager.csproj" -c Release -o /app/publish /p:UseAppHost=false

# končna slika
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TurnirManager.dll"]