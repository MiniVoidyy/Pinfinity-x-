#!/usr/bin/env bash
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== try deeper fetch for configs:"
git fetch --depth=500 edsheeran thirteen 2>&1 | tail -3
echo "== configs now?"
ls arch/configs/ 2>/dev/null | head -10
echo "== check if exynos defconfigs exist now:"
ls arch/configs/ 2>/dev/null | grep exynos | head -5
