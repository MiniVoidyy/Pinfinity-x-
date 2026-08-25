#!/usr/bin/env bash
echo "== vendor_framework src tree:"
curl -s "https://api.github.com/repos/PixelExperienceArchive/external_faceunlock/git/trees/thirteen?recursive=1" > /tmp/fu.json
grep -oE '"path": "[^"]+"' /tmp/fu.json | grep -E 'vendor_framework|\.java|\.aidl' | head -30
echo; echo "== size/truncated:"; grep -oE '"(truncated|size)": [a-z0-9]+' /tmp/fu.json
