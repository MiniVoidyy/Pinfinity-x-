#!/usr/bin/env bash
# Fetch the defconfig from the remote without full unshallow
cd ~/pinfinity-src/kernel/samsung/exynos9810
echo "== remote refs for thirteen:"
git ls-remote edsheeran thirteen 2>/dev/null | head -2
echo "== try sparse checkout for configs only:"
# Create a temp worktree to grab just configs
TMPDIR=$(mktemp -d)
git --work-tree="$TMPDIR" --git-dir=. checkout edsheeran/thirteen -- arch/configs/ 2>&1 | tail -3
ls "$TMPDIR/arch/configs/" 2>/dev/null | grep exynos | head -5
cp -r "$TMPDIR/arch/configs/" . 2>/dev/null
ls arch/configs/ | grep exynos | head -5
rm -rf "$TMPDIR"
