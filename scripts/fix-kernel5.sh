#!/usr/bin/env bash
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== arch/arm64/configs:"
git ls-tree HEAD arch/arm64/configs/ 2>/dev/null | head -10
echo "== arch/arm/configs:"
git ls-tree HEAD arch/arm/configs/ 2>/dev/null | grep exynos | head -5
echo "== find all defconfigs in git:"
git ls-tree -r --name-only HEAD | grep 'defconfig' | grep -i exynos | head -10
echo "== find starlte defconfig:"
git ls-tree -r --name-only HEAD | grep -i starlte | head -10
echo "== build.config.universal9810:"
git show HEAD:build.config.universal9810 2>/dev/null | head -10
