#!/usr/bin/env bash
for d in vendor_framework dependencies prebuilt; do
  echo "== $d:"
  curl -s "https://api.github.com/repos/PixelExperienceArchive/external_faceunlock/contents/$d?ref=thirteen" |
    grep -oE '"name": "[^"]+"'
done
echo "== patches.sh:"
curl -s "https://raw.githubusercontent.com/PixelExperienceArchive/external_faceunlock/thirteen/patches.sh" | head -30
