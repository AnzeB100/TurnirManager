var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "TurnirManager deluje!");

app.MapGet("/health", () => Results.Ok(new { status = "ok"}));

app.Run();
