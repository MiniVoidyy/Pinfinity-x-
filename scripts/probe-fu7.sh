#!/usr/bin/env bash
echo "== crdroid branches:"
curl -s "https://api.github.com/repos/crdroidandroid/android_frameworks_base/branches?per_page=100" | grep -oE '"name": "[^"]+"' | head -20
echo "== check FaceUnlockUtils on likely branches:"
for b in td lineage-20 thirteen v9 twelfth; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://raw.githubusercontent.com/crdroidandroid/android_frameworks_base/$b/core/java/com/android/internal/util/custom/faceunlock/FaceUnlockUtils.java")
  echo "$b -> $code"
done
