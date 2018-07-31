FROM lukaszimmermann/arvados-jobs-jre:8
LABEL maintainer="luk.zim91@gmail.com"

USER root
WORKDIR /tmp
RUN  apt-get update -y && \
     apt-get install -y --no-install-suggests --no-install-recommends unzip wget && \
     wget https://bio.informatik.uni-jena.de/repository/dist-release-local/de/unijena/bioinf/ms/sirius/4.0/sirius-4.0-linux64-headless.zip && \
     unzip sirius-4.0-linux64-headless.zip && \
     find sirius-linux64-headless-4.0 -iname '*jar' -exec cp {} /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/ \; && sync && \
     echo "#!/usr/bin/env bash" > /usr/local/bin/sirius && \
     echo 'exec /usr/bin/java $DEFAULT_JVM_OPTS $JAVA_OPTS $SIRIUS_OPTS de.unijena.bioinf.ms.cli.SiriusCLIApplication "$@"' >> /usr/local/bin/sirius && \
     chmod +x /usr/local/bin/sirius && \
     apt-get purge -y unzip wget && \
     apt-get --purge -y autoremove && \
     apt-get -y autoclean && \
     apt-get -y clean && \
     rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
     mkdir -p /tmp/crunch-job /tmp/crunch-src && \
     chown -R crunch:crunch /tmp/crunch-job /tmp/crunch-src
USER crunch
WORKDIR /

