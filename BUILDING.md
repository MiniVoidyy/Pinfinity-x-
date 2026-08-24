# Building Pinfinity X

Target: **Pixel Experience 13** for Galaxy S9 / S9+ / Note 9 (Exynos 9810),
built inside **WSL2 Ubuntu 22.04**, with all source on the **1 TB drive (B:)**.

> Hardware requirement: **Intel VT-x must be enabled in BIOS/UEFI**
> (Virtualization Technology). WSL2 cannot start without it.
> Also needs ~350 GB free on B: (source + out) and 16 GB+ RAM
> (`.wslconfig` is preconfigured: 28 GB RAM / 8 cores / swap on B:).

## 0. One-time Windows setup (done from PowerShell as admin)

```powershell
# after enabling VT-x in BIOS:
wsl --install -d Ubuntu-22.04 --no-launch
# move the distro disk to B: so the VM lives on the big drive:
mkdir B:\wsl
wsl --manage Ubuntu-22.04 --move B:\wsl\ubuntu2204
```

If `--move` isn't supported by your WSL version:

```powershell
wsl --export Ubuntu-22.04 B:\wsl\ubuntu.tar
wsl --unregister Ubuntu-22.04
wsl --import Ubuntu-22.04 B:\wsl\ubuntu2204 B:\wsl\ubuntu.tar --version 2
wsl -d Ubuntu-22.04   # first launch, create user "mini"
ubuntu2204.exe config --default-user mini
```

## 1. Bootstrap the toolchain (inside WSL)

```bash
bash wsl-setup.sh
```

Installs OpenJDK 11, build-essential, repo launcher, ccache (60 GB), etc.

## 2. Sync the source (~250 GB, one time)

From a checkout of this repository (or let the script download it):

```bash
bash sync-pinfinity.sh ~/pinfinity-src
```

What it does:

1. `repo init` against `https://github.com/PixelExperience/manifest`, branch `thirteen`
2. Drops `exynos9810.xml` (device/vendor/kernel trees from the
   `samsungexynos9810` org, branch thirteen) into `.repo/local_manifests/`
3. Drops `snippets/pinfinity.xml` so **this repo becomes `vendor/pinfinity`**
4. `repo sync`

## 3. Build

```bash
cd ~/pinfinity-src
bash vendor/pinfinity/scripts/build-pinfinity.sh starlte      # S9
bash vendor/pinfinity/scripts/build-pinfinity.sh star2lte     # S9+
bash vendor/pinfinity/scripts/build-pinfinity.sh crownlte     # Note9
# or all three sequentially:
bash vendor/pinfinity/scripts/build-pinfinity.sh all
```

Lunch targets are `pinfinity_<codename>-userdebug`. Before building,
`build-pinfinity.sh` automatically runs `wire-settings.sh`, which injects the
**"Pinfinity settings"** page (pinned at the top of the main Settings list)
into `packages/apps/Settings`. The wrappers in `vendor/pinfinity/products/`
auto-detect whether your device tree ships an `aosp_*.mk` or `lineage_*.mk`
base product and layer Pinfinity X on top of it.

Finished zips are copied to `/mnt/b/PinfinityX/releases/<codename>/`
(= `B:\PinfinityX\releases\<codename>` in Windows).

First full build takes roughly **3–6 h**; incremental builds are far faster.
Build all three devices back-to-back — they share most artifacts, so the
second and third builds take minutes.

## 4. Flash

1. Boot TWRP (Vol Up + Bixby + Power)
2. Wipe → Advanced: System, Data, Cache, Dalvik
3. Flash `pinfinity_*.zip`, then MindTheGapps-13.0.0-arm64 if you want GApps
   (PE `thirteen` non-plus has no GApps bundled)
4. Reboot

## Troubleshooting

| Symptom | Fix |
|---|---|
| `lunch: unknown target` | Device tree product name differs; check `ls device/samsung/starlte/*.mk` and adjust `PINFINITY_BASE_PRODUCT` in `vendor/pinfinity/products/pinfinity_starlte.mk` |
| `ENTRY_FRAGMENTS anchor not found` during wiring | Upstream SettingsGateway layout changed; open `packages/apps/Settings/src/com/android/settings/SettingsGateway.java`, add `PinfinitySettingsFragment.class.getName(),` to the list manually, rerun `wire-settings.sh` |
| Out of memory during build | Lower `-j`: `mka bacon -j6` |
| `/mnt/b` sync extremely slow | Keep the source dir inside the Linux vhdx (`~/pinfinity-src`), only releases go to `/mnt/b` |
| Kernel build errors | Trees expect GCC 10/11 clang defaults from PE thirteen; don't override `TARGET_KERNEL_CLANG_*` |
