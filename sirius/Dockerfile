FROM openjdk:8u171-jdk-alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

WORKDIR /tmp
RUN wget https://bio.informatik.uni-jena.de/repository/dist-release-local/de/unijena/bioinf/ms/sirius/4.0/sirius-4.0-linux64-headless.zip && \
    unzip sirius-4.0-linux64-headless.zip && \
    rm sirius-4.0-linux64-headless.zip && \
    find /tmp/sirius-linux64-headless-4.0/lib -type f -iname '*.jar' -exec cp {} /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext \; && sync && \
    echo "#!/usr/bin/env sh" > /usr/local/bin/sirius && \
    echo 'exec /usr/bin/java $DEFAULT_JVM_OPTS $JAVA_OPTS $SIRIUS_OPTS de.unijena.bioinf.ms.cli.SiriusCLIApplication "$@"' >> /usr/local/bin/sirius && \
    chmod +x /usr/local/bin/sirius && \
    rm -rf /tmp/* /var/tmp/*
ENTRYPOINT [ "sirius" ]
