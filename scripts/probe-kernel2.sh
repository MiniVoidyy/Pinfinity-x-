#!/usr/bin/env bash
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== git ls-tree arch/configs:"
git ls-tree HEAD arch/configs/ 2>/dev/null | head -10
echo "== .repo project xml:"
grep -n 'exynos9810\|kernel/samsung' ~/pinfinity-src/.repo/manifests/pixel.xml 2>/dev/null | head -5
echo "== clone depth:"
git rev-parse --is-shallow-repository 2>/dev/null
git log --oneline | wc -l
