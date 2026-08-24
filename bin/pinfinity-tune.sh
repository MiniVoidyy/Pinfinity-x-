#!/system/bin/sh
# ============================================================
# Pinfinity X - boot-time scheduler / VM tuning
# Runs once after sys.boot_completed=1 (see etc/init/pinfinity-tune.rc).
# Every write is guarded: nodes missing on your kernel are skipped.
# ============================================================

TAG="PinfinityTune"

w() {
  if [ -f "$1" ]; then
    echo "$2" > "$1" 2>/dev/null && log -t "$TAG" "$1 <= $2"
  fi
}

log -t "$TAG" "applying tunables..."

# ---- cpufreq / schedutil -------------------------------------------------
# Tighten rate limits so util updates are acted on quickly (~250us up,
# 20ms down) instead of the sluggish defaults.
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
  [ -d "$cpu/cpufreq" ] || continue
  w "$cpu/cpufreq/schedutil/up_rate_limit_us"      250
  w "$cpu/cpufreq/schedutil/down_rate_limit_us"    20000
  w "$cpu/cpufreq/schedutil/rate_limit_us"         250
  w "$cpu/cpufreq/schedutil/hispeed_load"          85
done

# ---- schedtune (EAS cgroup v1 boost) ------------------------------------
w /dev/stune/top-app/schedtune.boost       30
w /dev/stune/top-app/schedtune.prefer_idle 1
w /dev/stune/foreground/schedtune.boost    10
w /dev/stune/foreground/schedtune.prefer_idle 1
w /dev/stune/background/schedtune.boost    -5
w /dev/stune/background/schedtune.prefer_idle 0

# ---- VM ------------------------------------------------------------------
w /proc/sys/vm/swappiness            130
w /proc/sys/vm/vfs_cache_pressure    50
w /proc/sys/vm/dirty_ratio           15
w /proc/sys/vm/dirty_background_ratio 5
w /proc/sys/vm/page-cluster          0
w /proc/sys/vm/overcommit_memory     1

log -t "$TAG" "done"
exit 0
