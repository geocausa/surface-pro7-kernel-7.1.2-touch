#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

IMAGE_DEB="linux-image-7.1.2-surface+_7.1.2-surface-1_amd64.deb"
HEADERS_DEB="linux-headers-7.1.2-surface+_7.1.2-surface-1_amd64.deb"
LIBC_DEB="linux-libc-dev_7.1.2-surface-1_amd64.deb"
RELEASE_URL="https://github.com/geocausa/surface-pro7-kernel-7.1.2-touch/releases/download/v7.1.2-surface-1"

missing=0
for file in "$IMAGE_DEB" "$HEADERS_DEB"; do
  if [ ! -f "$file" ]; then
    echo "Missing $file"
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  echo "Downloading release packages..."
  for file in "$IMAGE_DEB" "$HEADERS_DEB" "$LIBC_DEB" SHA256SUMS; do
    curl -fL -O "$RELEASE_URL/$file"
  done
fi

if [ -f SHA256SUMS ]; then
  sha256sum -c SHA256SUMS --ignore-missing
fi

packages=("$IMAGE_DEB" "$HEADERS_DEB")
if [ -f "$LIBC_DEB" ]; then
  packages+=("$LIBC_DEB")
fi

$SUDO dpkg -i "${packages[@]}"

$SUDO install -d /etc/apt/preferences.d
$SUDO install -m 0644 apt/no-linux-surface-kernel-or-libwacom \
  /etc/apt/preferences.d/no-linux-surface-kernel-or-libwacom

if [ ! -f /etc/apt/trusted.gpg.d/linux-surface.gpg ]; then
  curl -fsSL https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc |
    gpg --dearmor |
    $SUDO tee /etc/apt/trusted.gpg.d/linux-surface.gpg >/dev/null
fi

echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" |
  $SUDO tee /etc/apt/sources.list.d/linux-surface.list >/dev/null

$SUDO apt-get update
$SUDO apt-get install -y iptsd
$SUDO update-grub

echo
echo "Installed 7.1.2-surface+ and iptsd."
echo "Disable Secure Boot before rebooting into this kernel."
