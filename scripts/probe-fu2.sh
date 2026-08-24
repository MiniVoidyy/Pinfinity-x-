#!/usr/bin/env bash
echo "== Android.bp files in repo (thirteen):"
curl -s "https://api.github.com/repos/PixelExperienceArchive/external_faceunlock/git/trees/thirteen?recursive=1" |
  grep -oE '"path": "[^"]+"' | grep -iE 'bp$|mk$'
echo "== branches:"
curl -s "https://api.github.com/repos/PixelExperienceArchive/external_faceunlock/branches" |
  grep -oE '"name": "[^"]+"'
echo "== search framework name in rankalpha fork:"
curl -s "https://raw.githubusercontent.com/rankalpha/PixelExperience_external_faceunlock/thirteen/Android.bp" | grep -n faceunlock_vendor_framework | head -3
