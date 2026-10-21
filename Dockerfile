# ==============================================================================
# DISCORD VC COUNTER BOT • PRODUCTION DOCKERFILE
# Multi-stage / Hardened Non-Root Container
# ==============================================================================

FROM python:3.12-slim AS runtime

# Set environment flags for optimal container performance
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PORT=8000 \
    HOST=0.0.0.0

# Install required system packages for health check and sqlite
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Create dedicated non-root user and group
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /bin/bash -m appuser

WORKDIR /app

# Install Python dependencies first for efficient layer caching
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY --chown=appuser:appgroup bot.py /app/
COPY --chown=appuser:appgroup services/ /app/services/
COPY --chown=appuser:appgroup api/ /app/api/
COPY --chown=appuser:appgroup dashboard/ /app/dashboard/

# Prepare persistent data directory with proper ownership
RUN mkdir -p /app/data && chown -R appuser:appgroup /app/data

# Switch to unprivileged runtime user
USER appuser

# Expose web dashboard & WebSocket port
EXPOSE 8000

# Docker Healthcheck targeting FastAPI /health endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://127.0.0.1:8000/health || exit 1

# Launch bot and web server
CMD ["python", "bot.py"]
