#!/usr/bin/env bash
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== working tree arch dirs:"
ls arch/
echo "== arch/arm64/configs on disk:"
ls arch/arm64/configs/ 2>/dev/null | head -10
echo "== arch/configs on disk:"
ls arch/configs/ 2>/dev/null | head -10
echo "== git status:"
git status --short | head -10
echo "== checkout arch/arm64/configs:"
git checkout HEAD -- arch/arm64/configs/ 2>&1 | tail -3
ls arch/arm64/configs/ | grep exynos | head -5
echo "== create arch/configs symlink:"
mkdir -p arch/configs
cp arch/arm64/configs/exynos9810-starlte_defconfig arch/configs/ 2>/dev/null
ls arch/configs/
