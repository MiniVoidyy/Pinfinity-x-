#!/usr/bin/env bash
check() { # repo branch
  u="https://raw.githubusercontent.com/$1/$2"
  bp=$(curl -s "$u/Android.bp")
  if echo "$bp" | grep -q faceunlock_framework; then echo "$1@$2: BP HAS faceunlock_framework"; else echo "$1@$2: no"; fi
}
check Octavi-OS/platform_external_faceunlock thirteen
check Spark-Rom/external_faceunlock thirteen
check rankalpha/PixelExperience_external_faceunlock thirteen
echo "== FaceUnlockUtils.java candidates:"
for rb in "Octavi-OS/platform_frameworks_base thirteenth" "Spark-Rom/platform_frameworks_base thirteen" "PixelExperienceArchive/platform_frameworks_base thirteen"; do
  set -- $rb
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://raw.githubusercontent.com/$1/$2/core/java/com/android/internal/util/custom/faceunlock/FaceUnlockUtils.java")
  echo "$1@$2 -> $code"
done
