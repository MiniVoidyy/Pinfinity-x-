#!/usr/bin/env bash
# Create ld symlink so clang-14 can find it for host linking
CLANG_BIN=~/pinfinity-src/prebuilts/clang/host/linux-x86/clang-r450784d/bin
if [ ! -f "$CLANG_BIN/ld" ]; then
    ln -s "$CLANG_BIN/ld.lld" "$CLANG_BIN/ld"
    echo ">> created ld -> ld.lld symlink in clang bin"
else
    echo ">> ld already exists"
fi
ls -la "$CLANG_BIN"/ld
