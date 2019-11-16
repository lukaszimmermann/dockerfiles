FROM archlinux:latest
LABEL maintainer="luk.zim91@gmail.com"

COPY packages /tmp/packages
COPY copy_pkgs.sh /opt/copy_pkgs.sh
COPY install_aur.sh /opt/install_aur.sh 

ENV REPO "/opt/repository/files/aur/os/x86_64"
ENV BUILD_USER pkg
ENV GOPATH "/home/${BUILD_USER}/go"

SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

# Install dependencies for makepkg
USER root
WORKDIR /tmp
RUN pacman -Syyu --noconfirm \
      automake \
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
      qt5-webkit \
      bison \
      flex \
      jdk11-openjdk \
      speexdsp \
      autoconf \
      gtk2 \
      libidn \
      libxaw \
      speex \
      nodejs \
      asar \
      c-ares \
      hunspell \
      libevent \
      mailcap \
      mozilla-common \
      startup-notification \
      wget > /dev/null 2>&1 && \
    useradd -m -s /bin/bash "${BUILD_USER}" && \
    echo "${BUILD_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/cache/pacman/pkg && \
    su -c'/opt/install_aur.sh pikaur' "${BUILD_USER}" && \
    # Assemble list of all package names available in core, extra and community 
    pacman -Si | grep '^Name' | awk '{print $3}' | sort > /tmp/packages_all && \
    # Split packages into pacman and AUR packages
    cat /tmp/packages | sort > /tmp/packages_sorted && \
    rm /tmp/packages && \
    comm -23 /tmp/packages_sorted /tmp/packages_all > /tmp/packages_aur && \
    rm /tmp/packages_all  && \
    chmod 0444 /tmp/packages_aur && \
    su -c'gpg --recv-keys 702353E0F7E48EDB' "${BUILD_USER}" && \
    su -c'xargs pikaur -Sw --noconfirm < /tmp/packages_aur' "${BUILD_USER}" && \
    pacman -Rns --noconfirm \
      automake \
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
      qt5-webkit \
      bison \
      flex \
      jdk11-openjdk \
      speexdsp \
      autoconf \
      gtk2 \
      libidn \
      libxaw \
      speex \
      nodejs \
      asar \
      c-ares \
      hunspell \
      libevent \
      mailcap \
      mozilla-common \
      pikaur \
      startup-notification \
      wget > /dev/null 2>&1 && \
      pacman -Sc --noconfirm > /dev/null 2>&1 && \
      pacman -Scc --noconfirm > /dev/null 2>&1 && \
      rm -rf /tmp/* /var/tmp* && sync
    
ENTRYPOINT [ "/opt/copy_pkgs.sh", "${REPO}" ]

