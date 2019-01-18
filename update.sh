#!/usr/bin/env bash
set -e


BASEDIR="$(dirname $0)"
TAG_COMMAND=tag_command


CONTEXTS="$(find ${BASEDIR} -name $TAG_COMMAND -o -name Dockerfile | xargs dirname | uniq -d)"

for context in "${CONTEXTS}"; do
	# Build the image in the build context, get imageid
	image_id=
done

