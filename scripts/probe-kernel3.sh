#!/usr/bin/env bash
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== remote:"
git remote -v
echo "== branch:"
git branch -a
echo "== shallow log:"
git log --all --oneline | head -5
echo "== try fetching configs only:"
git ls-remote HEAD 2>/dev/null | head -1
echo "== repo manifest:"
grep -A3 'kernel/samsung/exynos9810' ~/pinfinity-src/.repo/manifests/*.xml 2>/dev/null | head -10
