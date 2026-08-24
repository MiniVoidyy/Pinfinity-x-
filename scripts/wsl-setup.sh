#!/usr/bin/env bash
# ============================================================
# Pinfinity X - one-time WSL/Ubuntu build-environment bootstrap
# Run INSIDE Ubuntu 22.04:   bash wsl-setup.sh
# ============================================================
set -euo pipefail

echo ">> installing AOSP build dependencies..."
sudo apt-get update -y
sudo apt-get install -y \
    git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev \
    libc6-dev-i386 lib32ncurses-dev x11proto-core-dev libx11-dev lib32z-dev \
    libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig imagemagick \
    python3 python3-pip openjdk-11-jdk rsync bc ccache lz4 libssl-dev

echo ">> installing repo launcher..."
mkdir -p "$HOME/bin"
curl -sL https://storage.googleapis.com/git-repo-downloads/repo -o "$HOME/bin/repo"
chmod a+x "$HOME/bin/repo"

grep -q "$HOME/bin" "$HOME/.bashrc" 2>/dev/null || \
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"

# git identity needed by repo
git config --global user.name  "${GIT_NAME:-Pinfinity Builder}"
git config --global user.email "${GIT_EMAIL:-builder@pinfinity.local}"
git config --global color.ui auto

echo ">> enabling ccache..."
ccache -M 60G

echo ">> done. Next: bash sync-pinfinity.sh"
