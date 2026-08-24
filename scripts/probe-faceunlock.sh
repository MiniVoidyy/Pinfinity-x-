#!/usr/bin/env bash
echo "== repo search:"
curl -s "https://api.github.com/search/repositories?q=external_faceunlock&per_page=10" |
  grep -oE '"full_name": *"[^"]+"'
echo "== code search for module name:"
curl -s "https://api.github.com/search/code?q=faceunlock_vendor_framework+in:file+filename:Android.bp" -H "Accept: application/vnd.github+json" | head -c 400
