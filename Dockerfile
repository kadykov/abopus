FROM python:3.13-alpine

LABEL org.opencontainers.image.source="https://github.com/kadykov/abopus"
LABEL org.opencontainers.image.description="Audiobook to Opus converter — efficient batch conversion optimized for voice content"
LABEL org.opencontainers.image.licenses="MIT"

# Install runtime dependencies
RUN apk add --no-cache \
    ffmpeg \
    opus \
    imagemagick

# Install the Python package
COPY pyproject.toml README.md LICENSE /app/
COPY src/ /app/src/
RUN pip install --no-cache-dir /app

# Set up volumes for input/output
VOLUME ["/input", "/output"]
WORKDIR /data

ENTRYPOINT ["abopus", "-s", "/input", "-o", "/output"]
