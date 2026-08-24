#!/usr/bin/env bash
A=$(du -sb "$HOME/pinfinity-src" 2>/dev/null | cut -f1)
sleep 45
B=$(du -sb "$HOME/pinfinity-src" 2>/dev/null | cut -f1)
echo "RATE_MB_MIN=$(( (B-A)*60/1048576/45 ))"
GB=$((B/1073741824))
FRAC=$(( (B%1073741824)*10/1073741824 ))
echo "TOTAL_GB=${GB}.${FRAC}"
