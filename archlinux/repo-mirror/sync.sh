#!/usr/bin/env bash
#
# The script to sync a local mirror of the Arch Linux repositories and ISOs
#
# Copyright (C) 2007 Woody Gilk <woody@archlinux.org>
# Modifications by Dale Blount <dale@archlinux.org>
# and Roman Kyrylych <roman@archlinux.org>
# Comments translated to German by Dirk Sohler <dirk@0x7be.de>
# Licensed under the GNU GPL (version 2)
set -euo pipefail

cmd () {
  rsync -rtLpv --delete-after --delay-updates --safe-links "${1}" "${2}" || true
}

msg () {
  echo ">> ${1}"
}

SYNC_HOME="$1"
SYNC_LOGS="${SYNC_HOME}/logs"
SYNC_FILES="${SYNC_HOME}/files"

msg "Sync target is: ${SYNC_HOME}"

# Set repositories to sync
SYNC_REPO=(core extra community)


SYNC_SERVER=rsync://ftp.halifax.rwth-aachen.de/archlinux/

msg "Sync server: ${SYNC_SERVER}"

mkdir -p "${SYNC_HOME}"
cd "${SYNC_HOME}"
mkdir -p files logs scripts
cd /tmp

if [ -z $SYNC_REPO ]; then
  # Sync a complete mirror
  msg "Sync all repositories"
  cmd "${SYNC_SERVER}" "${SYNC_FILES}"
else
  msg "Syncing these repos: ${SYNC_REPO}"
  # Sync repositories of $SYNC_REPO
  for repo in ${SYNC_REPO[@]}; do
    repo="$(echo ${repo} | tr [:upper:] [:lower:])"
    echo ">> Syncing ${repo} to ${SYNC_FILES}/${repo}"
    cmd "${SYNC_SERVER}/${repo}" "${SYNC_FILES}"
    sleep 5 
  done
fi
sync

