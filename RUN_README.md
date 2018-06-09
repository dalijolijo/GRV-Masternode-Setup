# Gravium (GRV) Masternode - Run Docker Image

## Adding firewall rules
Open needed ports on your docker host server.
```
ufw logging on
ufw allow 22/tcp
ufw limit 22/tcp
ufw allow 11000/tcp
ufw allow 11010/tcp
ufw default deny incoming 
ufw default allow outgoing 
yes | ufw enable
```

## Pull docker image
```
docker pull <repository>/grv-masternode
```

## Run docker container
```
docker run -p 11000:11000 -p 11010:11010 --name grv-masternode -e GRVPWD='NEW_GRV_PWD' -e MN_KEY='YOUR_MN_KEY' -v /home/gravium:/home/gravium:rw -d <repository>/grv-masternode
docker ps
```

## Debbuging within a container (after start.sh execution)
Please execute ```docker run``` without option ```--entrypoint bash``` before you execute this commands:
```
tail -f /home/gravium/.gravium/debug.log

docker ps
docker exec -it grv-masternode bash
  # you are inside the grv-masternode container
  root@container# supervisorctl status graviumd
  root@container# cat /var/log/supervisor/supervisord.log
  # Change to gravium user
  root@container# sudo su gravium
  gravium@container# cat /home/gravium/.gravium/debug.log
  gravium@container# gravium-cli getinfo
```

## Debbuging within a container during run (skip start.sh execution)
```
docker run -p 11000:11000 -p 11010:11010 --name grv-masternode -e GRVPWD='NEW_GRV_PWD' -e MN_KEY='YOUR_MN_KEY' -v /home/gravium:/home/gravium:rw --entrypoint bash <repository>/grv-masternode
```

## Stop docker container
```
docker stop grv-masternode
docker rm grv-masternode
```
