# v7.1.2-surface-aa3

Prebuilt kernel packages for Microsoft Surface Pro 7 touch/stylus support, with
Ubuntu AppArmor notification support added for Snap prompting.

This release supersedes `v7.1.2-surface-aa1`. It also includes the SoundWire
zero-link UBSAN fix and a clean Surface registry package build with no module
taint.

## Assets

- `linux-image-7.1.2-surface-aa3+_7.1.2-surface-aa3_amd64.deb`
- `linux-headers-7.1.2-surface-aa3+_7.1.2-surface-aa3_amd64.deb`
- `linux-libc-dev_7.1.2-surface-aa3_amd64.deb`
- `SHA256SUMS`

## Verified On

- Device: Microsoft Surface Pro 7
- Ubuntu: 26.04
- Booted kernel: `7.1.2-surface-aa3+`
- Secure Boot: disabled
- Touch daemon: `iptsd 3.1.0-1`
- Snap prompting: enabled and active

## Verified Runtime Signals

- `ipts` module loaded
- `surface_gpe` module loaded
- `surface_aggregator` module loaded
- `IPTS 045E:099F Touchscreen` detected
- `IPTS 045E:099F Stylus` detected
- `iptsd@dev-hidraw4.service` active
- AppArmor notification socket present at `/sys/kernel/security/apparmor/.notify`
- AppArmor notify policy feature present
- `snap.prompting-client.daemon.service` active after enabling
  `experimental.apparmor-prompting`
- Kernel taint value `0`
- No `surface_aggregator_registry` out-of-tree warning
- No SoundWire UBSAN shift-out-of-bounds warning

## Notes

`libwacom-surface` is not installed by the helper script because the package
available at build time would remove GNOME desktop packages on Ubuntu 26.04.

Secure Boot must be disabled unless you sign this kernel yourself.
