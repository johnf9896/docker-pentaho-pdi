# Original: https://github.com/accso/docker-pentaho-pdi
# This version: https://github.com/hfiel/docker-pentaho-pdi
FROM debian:stretch
LABEL maintainer="hector@hfiel.es" description="Pentaho PDI 8.1 container with X11"
RUN adduser --disabled-login --uid 1000 pentaho
RUN chown pentaho.pentaho /home/pentaho
ARG MAJOR_MINOR_VERSION=8.1
ARG VERSION=8.1.0.0-365
ENV FILENAME=pdi-ce-${VERSION}.zip
ENV URL=https://kent.dl.sourceforge.net/project/pentaho/Pentaho%20${MAJOR_MINOR_VERSION}/client-tools/${FILENAME}
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
	   curl \
	   unzip \
	   libwebkitgtk-1.0-0 \
	   libxtst6 \
     locales \
     default-jre \
     libc-bin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt \
    && echo "Downloading PDI from: ${URL}" \
    && curl -o /opt/${FILENAME} -L ${URL} \
    && cd /opt \
    && unzip ${FILENAME} \
    && rm ${FILENAME}

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
COPY assets/docker-entrypoint.sh /docker-entrypoint.sh
ENV DOCKER_USER=pentaho
RUN mkdir -p /home/${DOCKER_USER}/home_on_host
ENTRYPOINT [ "/docker-entrypoint.sh" ]
