#!/bin/bash
# Build Python server binary for all platforms

set -e

# Determine platform
PLATFORM=$(rustc --print host-tuple 2>/dev/null || echo "unknown")

echo "Building voicetoto-server for platform: $PLATFORM"

# Build Python binary
cd backend

# Check if PyInstaller is installed
if ! python -c "import PyInstaller" 2>/dev/null; then
    echo "Installing PyInstaller..."
    pip install pyinstaller
fi

# Build binary
python build_binary.py

# Create binaries directory if it doesn't exist
mkdir -p ../tauri/src-tauri/binaries

# Copy binary with platform suffix
if [ -f dist/voicetoto-server ]; then
    cp dist/voicetoto-server ../tauri/src-tauri/binaries/voicetoto-server-${PLATFORM}
    chmod +x ../tauri/src-tauri/binaries/voicetoto-server-${PLATFORM}
    echo "Built voicetoto-server-${PLATFORM}"
elif [ -f dist/voicetoto-server.exe ]; then
    cp dist/voicetoto-server.exe ../tauri/src-tauri/binaries/voicetoto-server-${PLATFORM}.exe
    echo "Built voicetoto-server-${PLATFORM}.exe"
else
    echo "Error: Binary not found in dist/"
    exit 1
fi

echo "Build complete!"
