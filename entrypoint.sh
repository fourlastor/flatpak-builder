#!/bin/bash
set -e

echo "Starting Flatpak Local Directory Creation..."

TARGET_DIR="/tmp/flatpak-local"
ZIP_PATH="/output/flatpak-local.zip"

# Create a clean target directory
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Get package from argument
PACKAGE_ID=$1

if [ -z "$PACKAGE_ID" ]; then
    echo "ERROR: No Flatpak package ID provided."
    echo "Usage: docker run --rm -v \$(pwd)/out:/output flatpak-builder <package-id>"
    exit 1
fi

echo "Installing $PACKAGE_ID..."
flatpak install -y flathub "$PACKAGE_ID"

# Get all installed refs to ensure dependencies are included in export
REFS=$(flatpak list --columns=ref)

echo "Exporting: $REFS"
flatpak create-usb "$TARGET_DIR" $REFS

echo "Zipping the output..."
if [ ! -d "/output" ]; then
    echo "WARNING: /output directory not found. Zipping to /tmp instead."
    ZIP_PATH="/tmp/flatpak-local.zip"
fi

cd "$TARGET_DIR"
zip -rq "$ZIP_PATH" .

echo "Done! Zip file created at $ZIP_PATH"
