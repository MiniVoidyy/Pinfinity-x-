# ============================================================
# Pinfinity X - shared product config
# Inherited by every pinfinity_* device product.
#
# NOTE: the Pinfinity X menu lives inside AOSP Settings ("Pinfinity
# settings", top of the main list). scripts/wire-settings.sh injects
# it into packages/apps/Settings; build-pinfinity.sh calls it
# automatically before every build.
# ============================================================

# ---- Packages -------------------------------------------------------------
PRODUCT_PACKAGES += \
    PinfinityXFrameworkOverlay \
    PinfinityXUltraOverlay

# ---- Files -----------------------------------------------------------------
PRODUCT_COPY_FILES += \
    vendor/pinfinity/bin/pinfinity-tune.sh:$(TARGET_COPY_OUT_SYSTEM_EXT)/bin/pinfinity-tune.sh \
    vendor/pinfinity/bin/pinfinity-defaults.sh:$(TARGET_COPY_OUT_SYSTEM_EXT)/bin/pinfinity-defaults.sh \
    vendor/pinfinity/etc/init/pinfinity-tune.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/pinfinity-tune.rc

# ---- Snappiness: HWUI / fling / renderer -----------------------------------
# Bigger caches = fewer jank-causing re-allocations; higher min/max fling
# velocity makes lists react faster and coast further.
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.pinfinity.version=1.0 \
    ro.pinfinity.rom=Pinfinity-X \
    ro.hwui.texture_cache_size=96 \
    ro.hwui.layer_cache_size=64 \
    ro.hwui.path_cache_size=40 \
    ro.hwui.gradient_cache_size=2 \
    ro.hwui.drop_shadow_cache_size=8 \
    ro.hwui.r_buffer_cache_size=12 \
    ro.min.fling_velocity=180 \
    ro.max.fling_velocity=14000

# ---- Memory management ------------------------------------------------------
# Cached Apps Freezer (Android 13 feature) on by default + tuned lmkd.
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.device_config.activity_manager_settings.cached_apps_freezer_enabled=true \
    ro.lmk.low=1001 \
    ro.lmk.medium=900 \
    ro.lmk.critical=0 \
    ro.lmk.kill_heaviest_task=true \
    ro.lmk.use_minfree_levels=true \
    pm.sleep_mode=1

# ---- OTA metadata -----------------------------------------------------------
PINFINITY_VERSION := 1.0
PINFINITY_BUILD_TYPE := UNOFFICIAL

PRODUCT_EXTRA_RECOVERY_KEYS :=
