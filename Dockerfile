FROM --platform=linux/amd64 ubuntu:22.04

LABEL maintainer="Jean-Baptiste Auvinet - https://github.com/jbauvinet-r7"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

WORKDIR /opt/

# Download the setup script
RUN IVM_URL="https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin" \
    && apt-get update \
    && apt-get install -y wget expect \
    && wget -O Rapid7Setup-Linux64.bin $IVM_URL \
    && chmod 700 Rapid7Setup-Linux64.bin \
    && ./Rapid7Setup-Linux64.bin -q -c -overwrite -Vfirstname='Rapid7' -Vlastname='Console' -Vcompany='Rapid7' -Vusername='nxadmin' -Vpassword1='nxpassword' -Vpassword2='nxpassword' -Vsys.component.typical\$Boolean=true -VinitService\$Boolean=true -Dinstall4j.suppressUnattendedReboot=true \
    && rm /opt/Rapid7Setup-Linux64.bin \
    && apt-get remove -y wget expect \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory for the collector
WORKDIR /opt/rapid7/nexpose/

# Expose required ports
EXPOSE 3780/tcp 40815/tcp

VOLUME ["/opt/rapid7/nexpose/nsc/logs/"]

ENTRYPOINT ["/opt/rapid7/nexpose"]
CMD ["run"]
