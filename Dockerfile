FROM python:3.13-alpine

LABEL org.opencontainers.image.source="https://github.com/kadykov/audiobook-opus-converter"
LABEL org.opencontainers.image.description="Audiobook to Opus converter — efficient batch conversion optimized for voice content"
LABEL org.opencontainers.image.licenses="MIT"

# Install runtime dependencies
RUN apk add --no-cache \
    ffmpeg \
    opus \
    imagemagick

# Copy the converter script
COPY convert_audiobooks.py /app/convert_audiobooks.py

# Set up volumes for input/output
VOLUME ["/input", "/output"]
WORKDIR /app

ENTRYPOINT ["python3", "convert_audiobooks.py", "-s", "/input", "-o", "/output"]
