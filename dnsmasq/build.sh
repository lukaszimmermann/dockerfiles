#!/usr/bin/env bash
set -e
OUTPUT="$(docker build --no-cache --pull --rm . | grep -Ee ^TAGME -ie success)"
TAG=


