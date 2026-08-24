#!/usr/bin/env bash
# ============================================================
# Pinfinity X - build script (run inside the synced tree)
# Usage:  bash build-pinfinity.sh [starlte|star2lte|crownlte|all]
#
# Zips land in /mnt/b/PinfinityX/releases/<codename>/
# ============================================================
set -o pipefail
unset ZSH_VERSION ZSH_NAME

DEVICES=("$@")
[ ${#DEVICES[@]} -eq 0 ] && DEVICES=(starlte)
[ "${DEVICES[0]}" = "all" ] && DEVICES=(starlte star2lte crownlte)

RELEASE_DIR=/mnt/b/PinfinityX/releases
mkdir -p "$RELEASE_DIR"

# Integrate the Pinfinity X page into AOSP Settings (idempotent)
bash "$PWD/vendor/pinfinity/scripts/wire-settings.sh" "$PWD"

export PATH="$HOME/bin:$PATH"
export USE_CCACHE=1
ccache -M 60G >/dev/null 2>&1 || true

. build/envsetup.sh

for dev in "${DEVICES[@]}"; do
    echo ""
    echo "==============================================="
    echo ">> Building Pinfinity X for $dev"
    echo "==============================================="
    lunch "pinfinity_${dev}-userdebug" || { echo "lunch failed for $dev"; continue; }
    mka bacon -j"$(nproc)" || { echo "BUILD FAILED for $dev"; continue; }

    mkdir -p "$RELEASE_DIR/$dev"
    find out/target/product/"$dev" -maxdepth 1 -name '*.zip' \
         -exec cp -v {} "$RELEASE_DIR/$dev/" \; || true
done

echo ">> done. releases in $RELEASE_DIR"
