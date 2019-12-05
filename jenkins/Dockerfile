FROM jenkins/jenkins:latest
LABEL maintainer="luk.zim91@gmail.com"

USER root
RUN apt-get update -y && \
    apt-get install -y --no-install-suggests --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    rm -rf /tmp/* /var/tmp/* && sync

USER jenkins
RUN /usr/local/bin/install-plugins.sh \
        git \
        github \
        github-oauth \
        greenballs \
        mattermost && sync

# Since nsremap is not activated yet
# And we need Access to Docker
USER root

