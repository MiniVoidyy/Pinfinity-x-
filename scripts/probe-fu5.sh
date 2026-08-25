#!/usr/bin/env bash
echo "== archive frameworks_base exists?"
curl -s https://api.github.com/repos/PixelExperienceArchive/frameworks_base | grep -m2 -E '"full_name"|"default_branch"'
echo "== faceunlock dir present?"
curl -s "https://api.github.com/repos/PixelExperienceArchive/frameworks_base/contents/core/java/com/android/internal/util/custom/faceunlock?ref=thirteen" |
  grep -oE '"name": "[^"]+"'
echo "== crdroid fallback:"
curl -s "https://api.github.com/repos/crdroidandroid/android_frameworks_base/contents/core/java/com/android/internal/util/custom/faceunlock?ref=lineage-20" |
  grep -oE '"name": "[^"]+"' | head
