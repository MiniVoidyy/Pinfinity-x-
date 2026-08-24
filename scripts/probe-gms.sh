#!/usr/bin/env bash
echo "== GitHub mirror check:"
for r in PixelExperience/vendor_gms PixelExperience/external_faceunlock ; do
  printf '%s -> ' "$r"
  curl -s "https://api.github.com/repos/$r" | grep -m1 '"size"' || echo "MISSING"
done

echo "== references in device trees:"
grep -rn 'faceunlock' "$HOME/pinfinity-src/device/samsung/" 2>/dev/null | head -5
grep -rn 'vendor/gms\|PIXEL_GMS' "$HOME/pinfinity-src/device/samsung/exynos9810-common/common.mk" \
     "$HOME/pinfinity-src/device/samsung/starlte/device.mk" 2>/dev/null | head -8

echo "== who declares these projects:"
grep -n 'faceunlock\|vendor_gms' "$HOME/pinfinity-src/.repo/manifests/snippets/"*.xml
