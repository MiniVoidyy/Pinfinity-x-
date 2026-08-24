#!/usr/bin/env bash
check() {
  echo "== $1 (branch $2)"
  curl -s "https://api.github.com/repos/$1/contents/products/gms.mk?ref=$2" | head -c 120
  echo
}
check crdroidandroid/android_vendor_gms thirteen
check PixelOS-AOSP/vendor_gms thirteen
check AospExtended/vendor_gms eleven
check LineageOS/android_vendor_google lineag-20
curl -s "https://api.github.com/search/repositories?q=vendor_gms+thirteen&per_page=8" | grep -m8 '"full_name"'
