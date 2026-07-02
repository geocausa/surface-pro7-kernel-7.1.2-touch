# Surface Pro 7 Linux 7.1.2 Touch + AppArmor Kernel

Prebuilt Ubuntu kernel packages for a Microsoft Surface Pro 7.

This build uses the official upstream Linux 7.1.2 source with the linux-surface
community touch/platform patches forward-ported for Surface Pro 7 touch and
stylus support. It also includes Ubuntu's AppArmor notification support so Snap
AppArmor prompting can run on this custom kernel.

## What Is Included

- Linux kernel `7.1.2-surface-aa3+`
- Surface touch modules:
  - `ipts`
  - `ithc`
  - `surface_hid`
  - `surface_gpe`
  - `surface_aggregator`
- `iptsd` install helper through the linux-surface package repository
- AppArmor notification support for Snap prompting
- Apt guardrail to avoid accidentally installing the older packaged
  `linux-image-surface` kernel

## Important

Secure Boot must be disabled before booting this custom kernel, unless you sign
the kernel and modules yourself.

The older Ubuntu kernels remain installed as fallback entries in GRUB.

## Quick Install

Clone this repository and run the installer. The release packages are downloaded
automatically.

```bash
git clone https://github.com/geocausa/surface-pro7-kernel-7.1.2-touch.git
cd surface-pro7-kernel-7.1.2-touch
sudo ./scripts/install.sh
sudo reboot
```

After reboot:

```bash
uname -r
systemctl status 'iptsd*'
journalctl -k -b | grep -Ei 'ipts|ithc|surface|mei|hid'
```

Expected kernel:

```text
7.1.2-surface-aa3+
```

Expected touch service:

```text
iptsd@... active (running)
```

## Files

- `scripts/install.sh` installs the kernel packages and `iptsd`.
- `apt/no-linux-surface-kernel-or-libwacom` prevents pulling the older
  linux-surface kernel or the Surface libwacom replacement packages.
- `SHA256SUMS` contains checksums for the release `.deb` files.

## Notes

`libwacom-surface` is intentionally not installed on Ubuntu 26.04 because the
currently available package would remove GNOME desktop packages on this system.
Touch and stylus input are provided by the kernel modules plus `iptsd`.

The build that produced these packages was verified booting on a Surface Pro 7:

- Secure Boot disabled
- `ipts` loaded
- `iptsd` running
- `IPTS 045E:099F Touchscreen` detected
- `IPTS 045E:099F Stylus` detected
- AppArmor notification socket present at `/sys/kernel/security/apparmor/.notify`
- Snap prompting client enabled and active after enabling
  `experimental.apparmor-prompting`
- No kernel taint from the Surface registry module
- SoundWire zero-link firmware path no longer triggers the kernel UBSAN warning
