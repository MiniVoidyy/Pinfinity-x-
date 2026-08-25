#!/usr/bin/env bash
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== top-level git ls-tree:"
git ls-tree HEAD | head -30
echo "== does arch/ dir exist in git?"
git ls-tree HEAD arch/ 2>/dev/null | head -5
echo "== fetch to get more history:"
git fetch --depth=100 edsheeran thirteen 2>&1 | tail -3
echo "== now ls-tree HEAD arch/configs:"
git ls-tree HEAD arch/configs/ 2>/dev/null | head -5
