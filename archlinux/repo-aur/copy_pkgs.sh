#!/bin/bash
set -euo pipefail

TARGET="$1"

rm -rf "${TARGET}"
mkdir -p "${TARGET}"

find "/home/pkg/.cache/pikaur/pkg" -iname '*pkg.tar.xz' -type f -exec mv {} "${TARGET}" \;
cd "${TARGET}"
find . -iname '*pkg.tar.xz' -type f -print0 | xargs -0 repo-add -v aur.db.tar.gz
sync

