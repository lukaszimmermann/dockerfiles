FROM archlinux:latest
LABEL maintainer="luk.zim91@gmail.com"

COPY packages /tmp/packages
COPY copy_pkgs.sh /opt/copy_pkgs.sh
COPY install_aur.sh /opt/install_aur.sh 

ENV BUILD_USER  pkg
ENV BUILD_MOUNT "/opt/repository"
ENV BUILD_REPO  "${BUILD_MOUNT}/files/aur/os/x86_64"
ENV GOPATH      "/home/${BUILD_USER}/go"

SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

# Install dependencies for makepkg
USER root
WORKDIR /tmp
RUN pacman -Syyu --noconfirm \
      awk \
      binutils \
      diffutils \
      fakeroot \
      file \
      gcc \
      gettext \
      git \
      gnupg \
      grep \
      go-pie \
      make \
      patch \
      pkgconf \
      pyalpm \
      sudo \
      unzip \
      which \
      libxss \
      gtk3 \
      iso-codes \
      avahi \
      brotli \
      polkit \
      libgusb \
      mesa \
      pango \
      dconf \
      cairo \
      fontconfig \
      freetype2 \
      python2 \
      python2-pyparsing  \
      python2-setuptools \
      python2-appdirs \
      python2-six \
      python \
      python-six \
      python-setuptools \
      r \
      zip \
      openssl \
      pixman \
      libyaml \
      lib32-glibc \
      ruby \
      gperf \
      rubygems \
      lib32-gcc-libs \
      jdk11-openjdk > /dev/null 2>&1 && \
    gpg --recv-keys 702353E0F7E48EDB > /dev/null 2>&1 && \
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
RUN gpg --recv-keys 702353E0F7E48EDB && \
    xargs pikaur -Sw --noconfirm < /tmp/packages_aur && sync

ENTRYPOINT [ "copy_pkgs.sh", "/opt/repository/files/aur/os/x86_64" ]
