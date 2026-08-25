#!/usr/bin/env bash
echo "== search: package internal util custom faceunlock"
curl -s "https://grep.app/api/search?q=package%20com.android.internal.util.custom.faceunlock" |
  head -c 1500
echo; echo
echo "== search: IFaceService.aidl"
curl -s "https://grep.app/api/search?q=IFaceServiceReceiver%20callback" | head -c 800
