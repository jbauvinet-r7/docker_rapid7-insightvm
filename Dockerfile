FROM --platform=linux/amd64 ubuntu:22.04

LABEL maintainer="Jean-Baptiste Auvinet - https://github.com/jbauvinet"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

WORKDIR /opt/

# Download the setup script and install required dependencies
RUN IVM_URL="https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin" \
    && apt-get update \
    && apt-get install -y wget expect xvfb x11-xserver-utils libxext6 libxi6 libxtst6 \
    && mkdir -p /usr/X11R6/bin \
    && ln -s /usr/bin/Xvfb /usr/X11R6/bin/Xvfb \
    && wget -O Rapid7Setup-Linux64.bin $IVM_URL \
    && chmod 700 Rapid7Setup-Linux64.bin \
    && ./Rapid7Setup-Linux64.bin -q -c -overwrite -Vfirstname='Rapid7' -Vlastname='Console' -Vcompany='Rapid7' -Vusername='nxadmin' -Vpassword1='nxpassword' -Vpassword2='nxpassword' -Vsys.component.typical\$Boolean=true -VinitService\$Boolean=true -Dinstall4j.suppressUnattendedReboot=true \
    && rm /opt/Rapid7Setup-Linux64.bin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory for the collector
WORKDIR /opt/rapid7/nexpose/

# Expose required ports
EXPOSE 3780/tcp 40815/tcp

VOLUME ["/opt/rapid7/nexpose/nsc/logs/"]

# Create a startup script that runs the nexposeconsole
RUN echo '#!/bin/bash\n\
cd /opt/rapid7/nexpose\n\
mkdir -p /opt/rapid7/nexpose/nsc/logs\n\
./nsc/nexposeconsole.rc start\n\
echo "Waiting for service to initialize..."\n\
sleep 30\n\
while true; do\n\
  if [ -f /opt/rapid7/nexpose/nsc/logs/nsc.log ]; then\n\
    tail -f /opt/rapid7/nexpose/nsc/logs/nsc.log\n\
    break\n\
  else\n\
    echo "Waiting for log file to be created..."\n\
    sleep 10\n\
  fi\n\
done' > /opt/start_nexpose.sh && chmod +x /opt/start_nexpose.sh

CMD ["/opt/start_nexpose.sh"]
