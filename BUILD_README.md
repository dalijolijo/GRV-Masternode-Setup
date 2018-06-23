# Gravium (GRV) Masternode - Build Docker Image

The Dockerfile will install all required stuff to run a Gravium (GRV) Masternode.

## Requirements
- Linux Ubuntu 16.04 LTS
- Running as docker host server (package docker-ce installed)
```
sudo curl -sSL https://get.docker.com | sh
```

## Needed files
- Dockerfile
- gravium.conf
- gravium.sv.conf
- start.sh

## Allocating 2GB Swapfile
Create a swapfile to speed up the building process. Recommended if not enough RAM available on your docker host server.
```
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

## Build docker image
```
docker build -t grv-masternode .
```

## Push docker image to hub.docker
```
docker tag grv-masternode <repository>/grv-masternode
docker login -u <repository> -p"<PWD>"
docker push <repository>/grv-masternode:<tag>
```
