# Pinfinity X

**Pixel Experience 13, rebuilt for speed — with an Infinity-X style feature hub built in.**

A custom Android 13 ROM for the Samsung Exynos 9810 family, layering a
performance/"snappiness" stack and a full **Pinfinity X** settings menu on top of
Pixel Experience 13 (branch `thirteen`).

## Supported devices

| Device | Codename | Model |
|---|---|---|
| Galaxy S9 | `starlte` | SM-G960F |
| Galaxy S9+ | `star2lte` | SM-G965F |
| Galaxy Note9 | `crownlte` | SM-N960F |

Snapdragon variants (qualcomm) are **not** supported by these trees.

## What's inside

### Performance / snappiness layer (`vendor/pinfinity/common.mk`)
- Faster global animation durations + lower scroll friction (static framework RROs)
- HWUI cache upsizing, tuned fling velocity props
- Cached Apps Freezer on by default, tuned LMK levels
- Boot-time scheduler tuning: schedutil rate limits, schedtune (stune) top-app boost,
  VM watermark tuning (`vendor/pinfinity/bin/pinfinity-tune.sh`)
- Optional ultra overlay for even faster UI response

### Pinfinity settings menu (embedded in AOSP Settings)
Pinned at the **top of the main Settings list** as **"Pinfinity settings"**
(injected into `packages/apps/Settings` by `scripts/wire-settings.sh`,
which runs automatically before every build):
- **Performance**: animation scales, scroll profile switcher (balanced/ultra overlay),
  cached-app freezer toggle, RAM management profiles, background process limit,
  HWUI renderer picker (GL/Vulkan), fstrim now
- **UI/System**: font & display size, dark theme override, show-taps / pointer location,
  quick dev toggles
- **Gaming**: per-game GameManager performance/battery modes, kernel thermal profile,
  DND-while-gaming
- **Maintenance**: restart SystemUI, trim caches, soft reboot

First boot applies sane "snappy" defaults automatically (`pinfinity-defaults.sh`).

## Repo layout (this repo = `vendor/pinfinity` in the ROM tree)

```
snippets/pinfinity.xml        local-manifest addition (clones this repo into the tree)
scripts/wsl-setup.sh          build-dependency bootstrap for Ubuntu 22.04 (WSL2)
scripts/sync-pinfinity.sh     repo init PE13 + all manifests + full sync
scripts/wire-settings.sh      injects the Pinfinity settings page into AOSP Settings
scripts/build-pinfinity.sh    lunch + mka bacon per device, zips copied to releases/
vendor/pinfinity/common.mk    inheritable product config (props, packages, copies)
vendor/pinfinity/products/    pinfinity_starlte / star2lte / crownlte wrappers
vendor/pinfinity/overlay/     framework RROs (balanced + ultra)
vendor/pinfinity/bin/         boot-time tune + first-boot defaults scripts
vendor/pinfinity/etc/init/    init rc hook
vendor/pinfinity/patches/packages_apps_Settings   the embedded Settings page
```

## Build it

See [BUILDING.md](BUILDING.md). Short version (WSL2 Ubuntu 22.04):

```bash
bash vendor/pinfinity/scripts/wsl-setup.sh      # once
bash vendor/pinfinity/scripts/sync-pinfinity.sh # ~250 GB download to B:
bash vendor/pinfinity/scripts/build-pinfinity.sh starlte
```

## Credits

- [PixelExperience](https://github.com/PixelExperience) — base ROM (AOSP 13)
- [samsungexynos9810](https://github.com/samsungexynos9810) org ("V2", branch thirteen) — device/vendor/kernel trees
- [LineageOS](https://lineageos.org) — hardware.samsung & years of exynos9810 groundwork
- Infinity-X ROM team — feature inspiration
