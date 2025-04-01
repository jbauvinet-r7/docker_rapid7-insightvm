# Rapid7 InsightVM Console as a Docker Container

**Unofficial** Docker container image for the [Rapid7 InsightVM Console](https://docs.rapid7.com/insightvm/insightvm-quick-start-guide/).

This Docker container is intended for use in lab environments. It allows for easy deployment and testing of the Rapid7 InsightVM Console.

## Warning

This is **NOT** supported by Rapid7!

## Running the InsightVM Console Container

Replace the volume paths with valid directories on your Docker host, and set an FQDN!

### Network
The following configuration starts the container using the host network. This way, you don't need to forward all ports from the host to the container every time you add a new event source. If you only want other containers to send logs, you can remove the `network_mode` line and use Docker's internal network.  

### Persistant Storage
The volumes mount host directories into the container to preserve logs, configuration, and local cache.

### docker-compose.yml

```
---
services:
  rapid7-insightvm:
    image: jbauvinet/docker_rapid7-insightvm
    container_name: rapid7-insightvm
    hostname: insightvm.domain.com
    volumes:
      - /path/to/persistent/storage/logs/:/opt/rapid7/nexpose/nsc/logs/
    network_mode: "host"
    restart: unless-stopped
```

### Run command 

```
docker run \
        -d \
        --restart=unless-stopped \
        --network=host \
        --hostname insightvm.domain.com \
        -v /path/to/persistent/storage/logs/:/opt/rapid7/nexpose/nsc/logs/ \
        --name rapid7-insightvm \
        jbauvinet/docker_rapid7-insightvm
```

## First start instructions

After starting the InsightVM Console for the first time, wait a few ilnutes and login with:

`https://insightvm.domain.com:3780`

Username: `nxadmin`  
Password: `nxpassword`

Then, [activate the InsightVM Console](https://docs.rapid7.com/insightvm/insightvm-quick-start-guide/).

## Build Your Own Image

You can build your own image on the fly using: 

`docker build -t rapid7-insightvm .`  

This command creates a fresh image with the latest InsightVM Console version.

Since the setup automatically starts the InsightVM Console, it generates unique files such as certificates, meaning this image can only be used once. To avoid this limitation, you can [manually create the image](Manual_Image_Creation.md).

## Feedback & Improvements

You can give feedback on the [Rapid7 Discuss Board](https://discuss.rapid7.com/t/insightidr-collector-as-a-docker-container/3483).

For bugs and improvements please [create an issue](https://github.com/jbauvinet-r7/docker_rapid7-insightvm/issues) or send a [pull request](https://github.com/jbauvinet-r7/docker_rapid7-insightvm/pulls).