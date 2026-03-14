# abopus — Audiobook to Opus Converter

[![PyPI Version](https://img.shields.io/pypi/v/abopus)](https://pypi.org/project/abopus/)
[![PyPI Python Version](https://img.shields.io/pypi/pyversions/abopus)](https://pypi.org/project/abopus/)
[![PyPI Downloads](https://img.shields.io/pypi/dm/abopus)](https://pypi.org/project/abopus/)
[![License](https://img.shields.io/github/license/kadykov/abopus)](https://github.com/kadykov/abopus/blob/main/LICENSE)

A tool that efficiently converts audiobooks to the [Opus format](https://opus-codec.org/), optimized for voice content. Achieves significant file size reduction while maintaining excellent audio quality, with automatic parallel processing using all CPU cores.

## Features

- ✅ **Fast** - Parallel processing using all CPU cores by default
- ✅ **High Compression** - Opus codec works well for voice content
- ✅ **Quality Preserved** - Maintains metadata, directory structure, and cover art
- ✅ **Smart** - Skips already converted files; copies Opus files if already optimal
- ✅ **Flexible Stereo Handling** - Downmix to mono, keep stereo, or increase bitrate
- ✅ **Cover Image Support** - Automatically copies and optimizes cover images
- ✅ **Simple** - Single command with sensible defaults
- ✅ **Flexible** - Supports MP3, M4A, M4B, AAC, FLAC, WAV, OGG, WMA, Opus

## Quick Start

### Option 1: pipx / uvx (recommended)

No clone needed — just install and run:

```bash
# Install with pipx (persistent install)
pipx install abopus

# Or run directly with uvx (no install needed)
uvx abopus -s ~/Audiobooks -o ~/Audiobooks_Opus
```

> **Note:** FFmpeg must be installed on your system (`sudo apt install ffmpeg` / `brew install ffmpeg`).

### Option 2: Docker

Zero dependencies — only Docker required:

```bash
docker run --rm \
  -v ./audiobooks:/input \
  -v ./output:/output \
  ghcr.io/kadykov/abopus

# With custom options
docker run --rm \
  -v ./audiobooks:/input \
  -v ./output:/output \
  ghcr.io/kadykov/abopus -b 32k --stereo keep
```

### Option 3: Run directly

```bash
# Install dependencies
sudo apt install ffmpeg python3 imagemagick  # Ubuntu/Debian
# or: brew install ffmpeg python3 imagemagick  # macOS

# Clone and run
git clone https://github.com/kadykov/abopus.git
cd abopus
python3 convert_audiobooks.py
```

Input files: `./original/` → Output files: `./opus/`

## Usage

### Basic Examples

```bash
# Convert with defaults (all CPU cores, 24k bitrate, downmix stereo to mono)
abopus

# Custom directories
abopus -s ~/Audiobooks -o ~/Audiobooks_Opus

# Specific number of workers
abopus -w 4

# High quality
abopus -b 32k

# Keep stereo files as stereo
abopus --stereo keep

# Increase bitrate for stereo files (32k)
abopus --stereo increase-bitrate

# Verbose output
abopus -v
```

### Options

```plain
-s, --source DIR       Source directory (default: ./original)
-o, --output DIR       Output directory (default: ./opus)
-b, --bitrate RATE     Bitrate: 15k, 20k, 24k, 32k, 40k, 48k, etc. (default: 24k)
-w, --workers NUM      Parallel workers (default: CPU count)
--stereo STRATEGY      Stereo handling: downmix, keep, increase-bitrate (default: downmix)
--no-images            Skip copying cover images
--no-skip              Re-convert existing files
-v, --verbose          Verbose output
--no-color             Disable colors
-h, --help             Show help
```

## Quality Settings

Opus bitrate selection for audiobooks should balance file size with audio quality. The following recommendations are based on the Opus specification ([RFC 7587](https://www.rfc-editor.org/rfc/rfc7587.html)), codec developer guidance ([Xiph.org](https://wiki.xiph.org/Opus_Recommended_Settings)), and empirical testing.

### Bitrate Reference Table

| Bitrate (mono) | Audio Bandwidth | Quality Characteristics | Recommended Use |
| -------------- | --------------- | ----------------------- | --------------- |
| **12–16 kbps** | Mediumband → Wideband (~8 kHz) | Narrower frequency range, reduced clarity in high frequencies | Maximum compression, low-quality source recordings |
| **16–20 kbps** | Wideband (~8 kHz) | Good speech intelligibility, some bandwidth limitations | Balanced quality/size for basic audiobooks |
| **20–24 kbps** | Wideband / beginning Super-wideband | Improved clarity, approaching wider frequency response | General purpose audiobooks |
| **24–28 kbps** | Super-wideband (~12 kHz) | Natural speech quality, better high-frequency response | Recommended minimum for quality audiobooks |
| **28–32 kbps** | Fullband (0–20 kHz) | Full audio bandwidth, excellent clarity | High-quality recordings |
| **32–40 kbps** | Fullband (0–20 kHz) | Strong fullband quality with headroom | Professional audiobooks, complex audio |
| **40–64 kbps** | Fullband (0–20 kHz) | Very high fidelity, transparent quality | Studio recordings, audiobooks with music/effects |

**Sources:**

- IETF standard recommended sweet spots: 16–20 kbps for wideband speech, 28–40 kbps for fullband speech ([RFC 7587](https://www.rfc-editor.org/rfc/rfc7587.html))
- Xiph.org suggests ~24 kbps as where fullband coverage begins for speech, with higher bitrates for consistent fullband clarity ([Opus Recommended Settings](https://wiki.xiph.org/Opus_Recommended_Settings))
- Additional context from [Hydrogen Audio Wiki](https://wiki.hydrogenaudio.org/index.php?title=Opus#Speech_encoding_quality)

### Objective Quality Measurements

MUSHRA-type listening tests ([Google 2011](https://www.opus-codec.org/static/comparison/GoogleTest1.pdf)) on speech samples show:

- **32 kbps**: 97.2 / 100 (near-transparent quality)
- **20 kbps**: 77.9 / 100 (good quality with noticeable differences)
- **Original**: 99.3 / 100

These results indicate that 32 kbps achieves near-transparent quality for most speech, while 20 kbps provides good but not transparent quality.

### Practical Recommendations

**For most audiobooks:**

- **24–32 kbps** — Recommended range balancing quality and file size
  - 24 kbps: Default setting; Xiph.org recommended minimum for fullband mono speech
  - 32 kbps: Near-transparent quality based on listening tests

**For maximum compression:**

- **16–20 kbps** — Acceptable quality with significant size savings
  - 20 kbps: Good quality (77.9/100 in tests), smaller file sizes
  - 16 kbps: Wideband coverage, suitable for basic recordings

**For high-quality/archival:**

- **40–64 kbps** — Very high fidelity, minimal quality loss
  - Useful for studio recordings or content with music/sound effects

**Additional notes:**

- Opus uses **Variable Bitrate (VBR)** by default, adapting to audio complexity for better efficiency
- For stereo files with `--stereo increase-bitrate`, bitrates automatically increase by 60% (e.g., 24k → 38k)
- Any bitrate value can be specified (e.g., 19k, 26k, 35k) — Opus VBR is flexible
- Bandwidth transitions depend on encoder version and content; newer libopus versions may achieve fullband at slightly lower bitrates

### Why Bitrate Recommendations Vary

You may encounter different bitrate-to-bandwidth mappings across sources due to:

- **Standards vs. empirical guidance**: IETF specifications define ideal sweet spots, while community resources (Xiph.org, Hydrogen Audio) reflect actual encoder behavior and listening experience
- **Encoder evolution**: Newer libopus versions can achieve better quality at lower bitrates than older versions
- **Content dependency**: Encoder decisions vary based on audio complexity, frame size, and input characteristics
- **Subjective vs. objective definitions**: "Fullband quality" may refer to technical bandwidth (0–20 kHz) or subjective listener perception

## Stereo Handling

The script provides three strategies for handling multi-channel audio:

### downmix (Default)

Converts stereo to mono, preserving more bitrate for voice clarity. Best for audiobooks where narration is the primary focus.

```bash
abopus --stereo downmix
```

### keep

Keeps stereo files as-is. At lower bitrates (e.g., 24k or below), Opus may partially downmix stereo anyway.

```bash
abopus --stereo keep
```

### increase-bitrate

Automatically increases bitrate for stereo files by 60% to preserve stereo imaging. Examples:

- 15k → 24k
- 20k → 32k
- 24k → 38k (default)
- 32k → 51k
- 40k → 64k

```bash
abopus --stereo increase-bitrate
```

## Technical Details

**Codec Settings:**

- Opus at 24 kbps VBR (Variable Bitrate) by default
- VOIP mode (optimized for speech)
- Compression level 10 (maximum quality)
- Preserves all metadata and cover art
- Smart handling: Copies Opus files if source bitrate ≤ target bitrate
- Stereo downmixing to mono (default) for better voice quality

**Supported Formats:**

- Input: MP3, M4A, M4B, AAC, FLAC, WAV, OGG, WMA, Opus
- Output: Opus (.opus)

**Cover Images:**

- Automatically finds and copies common cover files:
  - Names: cover, folder, album, front
  - Formats: .jpg, .jpeg, .png, .webp
- Optimizes images (requires ImageMagick): resizes to max 1200px, reduces quality to 85%, strips metadata
- Falls back to simple copy if ImageMagick is not installed
- ImageMagick is commonly pre-installed on most Linux distributions

## Troubleshooting

```bash
# Check dependencies
abopus --help        # Should print help
ffmpeg -version      # Should be installed

# Verify Opus support
ffmpeg -codecs | grep opus

# Run with verbose output
abopus -v
```

## How It Works

1. Scans source directory recursively for audio files
2. Creates parallel workers (one per CPU core by default)
3. For each file:
   - If already Opus with bitrate ≤ target: copies file (no re-encoding)
   - Otherwise: converts using FFmpeg with Opus codec
   - Applies stereo strategy (downmix/keep/increase-bitrate)
4. Maintains directory structure and metadata
5. Copies and optimizes cover images (cover.jpg, folder.png, etc.)
6. Skips files that already exist in output directory

## Project Structure

```plain
abopus/
├── src/abopus/              # Python package
│   ├── __init__.py          # Version
│   ├── __main__.py          # python -m abopus entry point
│   └── converter.py         # Conversion logic
├── convert_audiobooks.py    # Compatibility shim
├── pyproject.toml           # Package metadata
├── Dockerfile               # Docker image
├── README.md                # Documentation
├── original/                # Place source files here (default)
│   └── Book Name/
│       └── chapter01.mp3
└── opus/                    # Converted files (auto-created)
    └── Book Name/
        └── chapter01.opus
```

## Installation

### pipx / uvx (recommended)

```bash
# Persistent install
pipx install abopus

# Or run without installing
uvx abopus --help
```

### Docker

```bash
docker run --rm \
  -v ./audiobooks:/input \
  -v ./output:/output \
  ghcr.io/kadykov/abopus
```

### pip

```bash
pip install abopus
```

### From source

```bash
git clone https://github.com/kadykov/abopus.git
cd abopus
pip install -e .
```

## Requirements

**Required (except Docker — everything is included):**

- Python 3.7 or later
- FFmpeg with libopus support

**Optional:**

- ImageMagick (for cover image optimization, usually pre-installed on Linux)

```bash
# Ubuntu/Debian
sudo apt install ffmpeg imagemagick

# Fedora
sudo dnf install ffmpeg ImageMagick

# Arch Linux
sudo pacman -S ffmpeg imagemagick

# macOS
brew install ffmpeg imagemagick
```
