#!/usr/bin/env bash
set -euo pipefail

PKG="$1"
cd /tmp
git clone "https://aur.archlinux.org/${PKG}.git" > /dev/null 2>&1
cd "${PKG}"
makepkg -sicC --check --noconfirm > /dev/null 2>&1
cd ..
rm -rf "/tmp/${PKG}"

