#!/usr/bin/env bash
echo "== arch dirs:"
ls ~/pinfinity-src/kernel/samsung/exynos9810/arch/ | head
echo "== configs:"
ls ~/pinfinity-src/kernel/samsung/exynos9810/arch/configs/ 2>/dev/null | head -20
echo "== exynos defconfigs:"
find ~/pinfinity-src/kernel/samsung/exynos9810/arch/configs/ -name '*exynos*' 2>/dev/null | head -10
echo "== kernel/samsung/exynos9810 git status:"
cd ~/pinfinity-src/kernel/samsung/exynos9810 && git log --oneline -2 2>/dev/null
