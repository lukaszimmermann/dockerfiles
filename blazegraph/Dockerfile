FROM openjdk:8u232-jre-slim-buster

SHELL [ "/bin/bash", "-eu", "-o", "pipefail", "-c" ]

COPY blazegraph.jar /opt/blazegraph/
WORKDIR /opt/blazegraph

ENTRYPOINT [ "java", "-jar", "/opt/blazegraph/blazegraph.jar" ] 
EXPOSE 9999
