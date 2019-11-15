FROM archlinux:latest
LABEL maintainer="luk.zim91@gmail.com"

COPY packages /tmp/packages
COPY copy_pkgs.sh /opt/copy_pkgs.sh
COPY install_aur.sh /opt/install_aur.sh 

ENV BUILD_USER pkg
ENV BUILD_MOUNT "/opt/repository"
ENV BUILD_REPO  "${BUILD_MOUNT}/files/aur/os/x86_64"

SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

# Install dependencies for makepkg
USER root
WORKDIR /tmp
RUN pacman -Syyu --noconfirm \
      awk \
      binutils \
      fakeroot \
      file \
      gcc \
      gettext \
      git \
      grep \
      go-pie \
      make \
      patch \
      pkgconf \
      pyalpm \
      sudo \
      unzip \
      which && \
    useradd -m -s /bin/bash "${BUILD_USER}" && \
    echo "${BUILD_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/cache/pacman/pkg && sync

# Install pikaur (AUR helper)
USER "${BUILD_USER}"
WORKDIR /tmp
RUN /opt/install_aur.sh pikaur && sync

# Assemble list of packages
USER root
WORKDIR /tmp
RUN \
    # Assemble list of all package names available in core, extra and community 
    pacman -Si | grep '^Name' | awk '{print $3}' | sort > /tmp/packages_all && \
    # Split packages into pacman and AUR packages
    cat /tmp/packages | sort > /tmp/packages_sorted && \
    rm /tmp/packages && \
    comm -23 /tmp/packages_sorted /tmp/packages_all > /tmp/packages_aur && \
    rm /tmp/packages_all  && \
    chmod 0444 /tmp/packages_aur && \
    mkdir -p "${BUILD_REPO}" && sync

USER "${BUILD_USER}"
WORKDIR /tmp
RUN xargs pikaur -Sw --noconfirm < /tmp/packages_aur && sync

ENTRYPOINT [ "copy_pkgs.sh", "/opt/repository/files/aur/os/x86_64" ]

