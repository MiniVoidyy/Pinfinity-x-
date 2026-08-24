#!/usr/bin/env bash
# ============================================================
# Pinfinity X - repo init + full source sync
# Usage:  bash sync-pinfinity.sh [target-dir]   (default ~/pinfinity-src)
#
# Base : Pixel Experience 13 (manifest branch "thirteen")
# Device trees : github.com/samsungexynos9810 local_manifests-V2 ("thirteen")
# Our layer    : github.com/MiniVoidyy/Pinfinity-x- -> vendor/pinfinity
#
# NOTE: ~250 GB download; put target-dir on the big drive if using
# a Windows mount (/mnt/b/...). Native ext4 inside the WSL vhdx is
# much faster than /mnt/*.
# ============================================================
set -euo pipefail

TARGET="${1:-$HOME/pinfinity-src}"
export PATH="$HOME/bin:$PATH"

mkdir -p "$TARGET"
cd "$TARGET"

echo ">> repo init (PixelExperience thirteen)..."
repo init -u https://github.com/PixelExperience/manifest -b thirteen \
     --depth=1

echo ">> installing local manifests..."
mkdir -p .repo/local_manifests
curl -sL https://raw.githubusercontent.com/samsungexynos9810/local_manifests-V2/main/exynos9810.xml \
     -o .repo/local_manifests/exynos9810.xml

# our own snippet: clone THIS repo as vendor/pinfinity.
# If you are running the script from a checkout of Pinfinity-x-,
# copy its snippets/pinfinity.xml instead of downloading.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/../snippets/pinfinity.xml" ]; then
    cp "$SCRIPT_DIR/../snippets/pinfinity.xml" .repo/local_manifests/pinfinity.xml
else
    curl -sL https://raw.githubusercontent.com/MiniVoidyy/Pinfinity-x-/main/snippets/pinfinity.xml \
         -o .repo/local_manifests/pinfinity.xml
fi

echo ">> syncing (this downloads ~250 GB - be patient)..."
repo sync -c -j8 --force-sync --no-clone-bundle --no-tags

echo ">> sync complete."
