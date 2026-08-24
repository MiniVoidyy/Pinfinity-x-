#!/usr/bin/env bash
for r in \
  samsungexynos9810/kernel_samsung_exynos9810 \
  OuiouiTrees/kernel_samsung_exynos9810 \
  Exynos9810Resurrected/android_kernel_samsung_exynos9810 ; do
  echo "== $r"
  curl -s "https://api.github.com/repos/$r" | grep -E '"default_branch"|"size"' | head -2
  echo "-- branches:"
  curl -s "https://api.github.com/repos/$r/branches?per_page=100" | grep -oE '"name": *"[^"]+"' | head -12
done

echo "=== searching Exynos9810Resurrected repos:"
curl -s "https://api.github.com/orgs/Exynos9810Resurrected/repos?per_page=100" | grep -oE '"full_name": *"[^"]+"' | head -20
