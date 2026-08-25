#!/usr/bin/env bash
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== git ls-tree HEAD arch/configs (does it exist in the commit?):"
git ls-tree HEAD arch/configs/ 2>/dev/null | head -5
echo "== shallow check:"
git rev-parse --is-shallow-repository
echo "== how many commits?"
git rev-list --count HEAD
echo "== branches:"
git branch -a | head -5
echo "== all remotes:"
git remote -v
