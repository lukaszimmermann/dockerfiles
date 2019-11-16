FROM archlinux:latest
LABEL maintainer="luk.zim91@gmail.com"

COPY packages packages_build /tmp/
COPY copy_pkgs.sh install_aur.sh /opt/
COPY mirrorlist /etc/pacman.d/mirrorlist

ENV REPO "/opt/repository/files/aur/os/x86_64"
ENV BUILD_USER pkg
ENV GOPATH "/home/${BUILD_USER}/go"

SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

USER root
WORKDIR /tmp
RUN xargs pacman -Syyu --noconfirm < /tmp/packages_build && \
    useradd -m -s /bin/bash "${BUILD_USER}" && \
    echo "${BUILD_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/cache/pacman/pkg && \
    su -c'/opt/install_aur.sh pikaur' "${BUILD_USER}" && \
    # Assemble list of all package names available in core, extra and community 
    pacman -Si | grep '^Name' | awk '{print $3}' | sort > /tmp/packages_all && \
    # Split packages into pacman and AUR packages
    sort /tmp/packages > /tmp/packages_sorted && \
    rm /tmp/packages && \
    comm -23 /tmp/packages_sorted /tmp/packages_all > /opt/packages_aur && \
    rm /tmp/packages_all  && \
    chmod 0444 /opt/packages_aur && \
    su -c'gpg --recv-keys 702353E0F7E48EDB' "${BUILD_USER}" && \
    su -c'xargs pikaur -Sw --noconfirm < /opt/packages_aur' "${BUILD_USER}" && \
    pacman -Rns --noconfirm pikaur && \
    xargs pacman -Rns --noconfirm < /tmp/packages_build && \
    pacman -Sc --noconfirm  && \
    pacman -Scc --noconfirm && \
    rm -rf /tmp/* \
           /var/tmp/* \
           "/home/${BUILD_USER}/.cache/pikaur/build" && sync
    
ENTRYPOINT [ "/opt/copy_pkgs.sh", "${REPO}" ]

