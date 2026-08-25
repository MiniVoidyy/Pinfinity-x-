#!/usr/bin/env bash
P="core/java/com/android/internal/util/custom/faceunlock/FaceUnlockUtils.java"
probe() { code=$(curl -s -o /dev/null -w "%{http_code}" "https://raw.githubusercontent.com/$1/$2/$3"); echo "$1@$2 -> $code"; }
probe crdroidandroid/android_frameworks_base 12.1 "$P"
probe crdroidandroid/android_frameworks_base 12.0 "$P"
probe crdroidandroid/android_frameworks_base 11.0 "$P"
probe DerpFest-AOSP/frameworks_base thirteen "$P"
probe DerpFest-AOSP/frameworks_base twelve "$P"
probe Evolution-X/frameworks_base udc "$P"
probe PixelOS-AOSP/frameworks_base thirteen "$P"
probe ArrowOS-android/frameworks_base arrow-13.0 "$P"
