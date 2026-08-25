#!/usr/bin/env bash
BP=$(curl -s https://raw.githubusercontent.com/PixelExperienceArchive/external_faceunlock/thirteen/Android.bp)
echo "== module names defined in root Android.bp:"
echo "$BP" | grep -E 'name: *"' | head -20
echo "== mentions of faceunlock_framework/vendor_framework:"
echo "$BP" | grep -c faceunlock_framework
echo "== top-level dirs:"
curl -s "https://api.github.com/repos/PixelExperienceArchive/external_faceunlock/contents?ref=thirteen" |
  grep -oE '"name": "[^"]+"'
