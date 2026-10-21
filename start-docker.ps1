<#
.SYNOPSIS
    Builds and starts the Discord VC Counter Bot inside a Docker container with all health checks.
#>

Write-Host "🚀 Starting Discord VC Counter Bot in Docker Container..." -ForegroundColor Cyan

if (!(Test-Path ".env")) {
    Write-Host "⚠️ .env file not found! Copying from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "📝 Please edit .env and set your DISCORD_BOT_TOKEN before continuing." -ForegroundColor Yellow
    exit 1
}

if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker is not currently installed or not in PATH on this machine." -ForegroundColor Red
    Write-Host "💡 To install Docker Desktop on Windows, run in an Administrator terminal:" -ForegroundColor Yellow
    Write-Host "   winget install Docker.DockerDesktop" -ForegroundColor White
    Write-Host "   Or download directly from: https://www.docker.com/products/docker-desktop" -ForegroundColor Cyan
    exit 1
}

New-Item -ItemType Directory -Force -Path "data" | Out-Null

Write-Host "📦 Building and launching container with Docker Compose..." -ForegroundColor Cyan
docker compose up -d --build

Write-Host "✅ Container launched successfully!" -ForegroundColor Green
Write-Host ""
docker compose ps
Write-Host ""
Write-Host "🩺 Healthcheck status will transition from 'starting' to 'healthy' after gateway connection." -ForegroundColor Cyan
Write-Host "📜 To follow live logs, run: docker compose logs -f" -ForegroundColor White
