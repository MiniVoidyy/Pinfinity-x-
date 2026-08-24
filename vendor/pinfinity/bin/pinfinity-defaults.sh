#!/system/bin/sh
# ============================================================
# Pinfinity X - one-time first-boot defaults ("snappy out of the box")
# Triggered once by pinfinity-tune.rc via persist.pinfinity.defaults_done.
# ============================================================

settings put system window_animation_scale 0.65
settings put system transition_animation_scale 0.65
settings put system animator_duration_scale 0.75

# ultra scroll overlay stays opt-in; ensure it starts disabled
cmd overlay disable --user 0 com.pinfinity.x.ultra.overlay 2>/dev/null

log -t PinfinityDefaults "first-boot defaults applied"
