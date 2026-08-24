#!/usr/bin/env bash
# quick throughput + progress probe for the pinfinity sync
A=$(du -sb "$HOME/pinfinity-src/.repo/projects" 2>/dev/null | cut -f1)
sleep 60
B=$(du -sb "$HOME/pinfinity-src/.repo/projects" 2>/dev/null | cut -f1)
echo "TOTAL_GB=$((B/1073741824)).$(( (B%1073741824)*10/1073741824 ))"
echo "RATE_MB_PER_MIN=$(( (B-A)/1048576 ))"
echo "GIT_PROCS=$(ps aux | grep -c '[g]it')"
