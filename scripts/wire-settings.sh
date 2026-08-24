#!/usr/bin/env bash
# ============================================================
# Pinfinity X - integrate the hub into AOSP Settings
#
#  * copies fragment/resources into packages/apps/Settings
#  * adds the "Pinfinity settings" tile at the TOP of the
#    main Settings list (top_level_settings.xml)
#  * registers the fragment in SettingsGateway.ENTRY_FRAGMENTS
#
# Idempotent: safe to run repeatedly.
# Usage:  bash wire-settings.sh [path-to-android-tree]
# ============================================================
set -euo pipefail

TREE="${1:-$PWD}"
SETTINGS_DIR="$TREE/packages/apps/Settings"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_SRC="$(cd "$SCRIPT_DIR/../patches/packages_apps_Settings" && pwd)"

if [ ! -d "$SETTINGS_DIR" ]; then
    echo "ERROR: $SETTINGS_DIR not found. Run this from the synced ROM tree." >&2
    exit 1
fi

echo ">> copying Pinfinity X page into Settings..."
cp -r "$PATCH_SRC"/. "$SETTINGS_DIR"/

python3 - "$SETTINGS_DIR" <<'PY'
import pathlib, re, sys

s = pathlib.Path(sys.argv[1])

# ---- 1) homepage tile, pinned to the top ---------------------------------
tile = (
    '    <Preference\n'
    '        android:key="top_level_pinfinity"\n'
    '        android:title="@string/pinfinity_title"\n'
    '        android:summary="@string/pinfinity_summary"\n'
    '        android:icon="@drawable/ic_pinfinity"\n'
    '        android:fragment="com.android.settings.pinfinity.'
    'PinfinitySettingsFragment"/>\n'
)

tl = s / "res/xml/top_level_settings.xml"
txt = tl.read_text()
if "top_level_pinfinity" in txt:
    print("   tile already present in top_level_settings.xml")
else:
    m = re.search(r"<Preference\b", txt)
    if m:
        txt = txt[: m.start()] + tile + txt[m.start() :]
    else:
        # fall back: right after the opening <PreferenceScreen ...> element
        m = re.search(r"<PreferenceScreen[^>]*>\n", txt)
        assert m, "could not locate an anchor in top_level_settings.xml"
        txt = txt[: m.end()] + "\n" + tile + txt[m.end() :]
    tl.write_text(txt)
    print("   tile pinned to top of Settings homepage")

# ---- 2) allow deep-launching the fragment ---------------------------------
gw = s / "src/com/android/settings/SettingsGateway.java"
if not gw.exists():
    # some trees split the gateway; search for it
    hits = list((s / "src").rglob("SettingsGateway.java"))
    assert hits, "SettingsGateway.java not found"
    gw = hits[0]

t = gw.read_text()
if "PinfinitySettingsFragment" in t:
    print("   fragment already registered in", gw.name)
else:
    t2, n = re.subn(
        r"(ENTRY_FRAGMENTS\s*=\s*\{\s*\n)",
        r"\1        com.android.settings.pinfinity."
        r"PinfinitySettingsFragment.class.getName(),\n",
        t,
        count=1,
    )
    assert n == 1, f"ENTRY_FRAGMENTS anchor not found in {gw}"
    gw.write_text(t2)
    print("   fragment registered in", gw.name)
PY

echo ">> Settings integration complete."

# ---------------------------------------------------------------------------
# Drop FaceUnlockService: PE's implementation needs modules from the dead
# gitlab.pixelexperience.org (external_faceunlock) and cannot build.
COMMON_MK="$TREE/vendor/aosp/config/common.mk"
if [ -f "$COMMON_MK" ] && grep -q 'FaceUnlockService' "$COMMON_MK"; then
    sed -i '/^\s*FaceUnlockService\s*$/d' "$COMMON_MK"
    echo ">> removed unbuildable FaceUnlockService from vendor/aosp"
fi

# ---------------------------------------------------------------------------
# Stub for PE's dead-gitlab vendor/gms (vendor/aosp hard-inherits
# vendor/gms/products/gms.mk, but gitlab.pixelexperience.org no longer
# resolves). A no-op stub keeps product config parsing happy; flash
# MindTheGapps-13.0.0-arm64 separately if you want Google apps.
GMS_DIR="$TREE/vendor/gms/products"
if [ ! -f "$GMS_DIR/gms.mk" ]; then
    mkdir -p "$GMS_DIR"
    cat > "$GMS_DIR/gms.mk" <<'EOF'
# Pinfinity X: minimal stub replacing PixelExperience vendor_gms
# (upstream gitlab is offline). No Google apps are bundled; flash
# MindTheGapps-13.0.0-arm64 after the ROM if you need them.
PINFINITY_GMS_STUB := true
EOF
    echo ">> created vendor/gms stub (no GApps bundled)"
fi
