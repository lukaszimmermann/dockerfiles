#!/bin/bash
#
# The script to sync a local mirror of the Arch Linux repositories and ISOs
#
# Copyright (C) 2007 Woody Gilk <woody@archlinux.org>
# Modifications by Dale Blount <dale@archlinux.org>
# and Roman Kyrylych <roman@archlinux.org>
# Comments translated to German by Dirk Sohler <dirk@0x7be.de>
# Licensed under the GNU GPL (version 2)
set -euo pipefail

SYNC_HOME="$1"
SYNC_LOGS="${SYNC_HOME}/logs"
SYNC_FILES="${SYNC_HOME}/files"

# Set repositories to sync
SYNC_REPO=(core extra community)

SYNC_SERVER=rsync://ftp.halifax.rwth-aachen.de/archlinux/

mkdir -p "${SYNC_HOME}"
cd "${SYNC_HOME}"
mkdir -p files logs scripts
cd /tmp

alias rsync2="rsync -rtLpv --delete-after --delay-updates --safe-links"

if [ -z $SYNC_REPO ]; then
  # Sync a complete mirror
  rsync2 "${SYNC_SERVER}" "${SYNC_FILES}"
else
  # Sync repositories of $SYNC_REPO
  for repo in ${SYNC_REPO[@]}; do
    repo="$(echo ${repo} | tr [:upper:] [:lower:])"
    echo ">> Syncing ${repo} to ${SYNC_FILES}/${repo}"
    rsync2 "${SYNC_SERVER}/${repo}" "${SYNC_FILES}"
    sleep 5 
  done
fi
unalias rsync2
sync

