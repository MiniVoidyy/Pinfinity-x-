#!/usr/bin/env bash
curl -s "https://api.github.com/repos/crdroidandroid/android_frameworks_base/contents/core/java/com/android/internal/util/custom/faceunlock?ref=13.0" |
  grep -oE '"name": "[^"]+"'
