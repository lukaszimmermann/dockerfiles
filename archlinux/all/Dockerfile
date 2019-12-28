FROM archlinux:latest

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]
USER root
WORKDIR /tmp
COPY packages /tmp/
RUN xargs pacman -Syyu --noconfirm < packages && sync

