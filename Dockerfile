FROM alpine:3.6

MAINTAINER Chiho Sin <chihosin@outlook.com>

ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre
ENV PENTAHO_VERSION=8.0 \
    PDI_BUILD=8.0.0.0-28 \
    JRE_HOME=${JAVA_HOME} \
    PENTAHO_JAVA_HOME=${JAVA_HOME} \
    PENTAHO_HOME=/opt/pentaho \
    KETTLE_HOME=/opt/pentaho/data-integration\
    PATH=${PATH}:${JAVA_HOME}/bin

RUN apk update && \
    apk add openjdk8-jre bash webkitgtk && \
    apk add --virtual build-dependencies ca-certificates openssl && \
    update-ca-certificates && \
    mkdir -p ${PENTAHO_HOME} && \
    wget -qO /tmp/pdi-ce.zip https://downloads.sourceforge.net/project/pentaho/Pentaho%20${PENTAHO_VERSION}/client-tools/pdi-ce-${PDI_BUILD}.zip && \
    unzip -q /tmp/pdi-ce.zip -d ${PENTAHO_HOME} && \
    rm -f /tmp/pdi-ce.zip && \
    apk del build-dependencies && \
    chmod -R g+w ${PENTAHO_HOME}

ADD docker-entrypoint.sh $KETTLE_HOME/docker-entrypoint.sh

VOLUME ["/opt/pentaho/repository"]
EXPOSE 7373

WORKDIR $KETTLE_HOME
CMD ["/bin/bash", "./docker-entrypoint.sh", "master"]
