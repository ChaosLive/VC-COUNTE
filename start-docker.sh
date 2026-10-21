#!/bin/bash
# ==============================================================================
# DISCORD VC COUNTER BOT • DOCKER LAUNCH SCRIPT
# Builds and starts container with persistent storage and health checks
# ==============================================================================
set -e

echo "🚀 Starting Discord VC Counter Bot in Docker Container..."

# Ensure .env exists
if [ ! -f .env ]; then
    echo "⚠️ .env file not found! Copying from .env.example..."
    cp .env.example .env
    echo "📝 Please edit .env with your DISCORD_BOT_TOKEN before continuing."
    exit 1
fi

# Check Docker CLI
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed on this machine!"
    echo "💡 Install Docker using: curl -fsSL https://get.docker.com | sh"
    exit 1
fi

# Ensure data directory exists with correct permissions
mkdir -p data

echo "📦 Building and starting container..."
docker compose up -d --build

echo ""
echo "✅ Container started successfully!"
echo "📋 Container status:"
docker compose ps
echo ""
echo "🩺 To inspect live logs, run:"
echo "   docker compose logs -f"
