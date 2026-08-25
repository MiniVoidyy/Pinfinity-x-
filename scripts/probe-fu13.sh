#!/usr/bin/env bash
D=~/pinfinity-src/frameworks/base/services/core/java/com/android/server/biometrics/sensors/face/custom
echo "== cleanup client daemon/remove:"
grep -n -B2 -A6 'remove\|getFreshDaemon' "$D/FaceInternalCleanupClient.java" | head -25
echo "== CustomFaceProvider generateChallenge/revokeChallenge wrappers:"
grep -n -A3 'scheduleGenerateChallenge\|scheduleRevokeChallenge\|generateChallengeInternal\|revokeChallengeInternal' "$D/CustomFaceProvider.java" | head -30
