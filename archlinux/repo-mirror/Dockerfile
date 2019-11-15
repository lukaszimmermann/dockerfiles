FROM archlinux:latest
LABEL maintainer="luk.zim91@gmail.com"

COPY sync.sh /opt/sync.sh
RUN pacman -Syyu --noconfirm rsync vsftpd && \
    chmod +x /opt/sync.sh && \
    pacman -Sc --noconfirm && \
    pacman -Scc --noconfirm && \
    rm -rf /tmp/* /var/tmp/* && sync

ENTRYPOINT [ "/opt/sync.sh", "/opt/mirror" ]
 
