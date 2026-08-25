#!/usr/bin/env bash
D=~/pinfinity-src/frameworks/base/services/core/java/com/android/server/biometrics/sensors/face/custom
for f in FaceInternalCleanupClient FaceInternalEnumerateClient FaceGenerateChallengeClient FaceRevokeChallengeClient FaceGetFeatureClient FaceResetLockoutClient FaceUpdateActiveUserClient; do
  echo "== $f"
  grep -h -A1 'getFreshDaemon()' "$D/$f.java" | head -3
done
echo "== CustomFaceProvider daemon calls:"
grep -n -A2 'getFreshDaemon()\|mFaceServices.get' "$D/CustomFaceProvider.java" | grep -v '^--$' | head -20
