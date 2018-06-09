#!/bin/bash
set -u

BOOTSTRAP='bootstrap.tar.gz'

#
# Set passwd of gravium user
#
echo gravium:${GRVPWD} | chpasswd

#
# Downloading gravium.conf
#
cd /tmp/
wget https://raw.githubusercontent.com/dalijolijo/GRV-Masternode-Setup/master/gravium.conf -O /tmp/gravium.conf
chown gravium:gravium /tmp/gravium.conf

#
# Set rpcuser, rpcpassword and masternode genkey
#
printf "** Set rpcuser, rpcpassword and masternode genkey ***\n"
mkdir -p /home/gravium/.gravium/
chown -R gravium:gravium /home/gravium/
sudo -u gravium cp /tmp/gravium.conf /home/gravium/.gravium/
sed -i "s/^\(rpcuser=\).*/rpcuser=grvmasternode${GRVPWD}/" /home/gravium/.gravium/gravium.conf
sed -i "s/^\(rpcpassword=\).*/rpcpassword=${GRVPWD}/" /home/gravium/.gravium/gravium.conf
sed -i "s/^\(externalip=\).*/externalip=${GRVIP}/" /home/gravium/.gravium/gravium.conf 
sed -i "s/^\(masternodeprivkey=\).*/masternodeprivkey=${MN_KEY}/" /home/gravium/.gravium/gravium.conf
cp /home/gravium/.gravium/gravium.conf /home/gravium/.graviumcore/gravium.conf

#
# Downloading bootstrap file (not yet available)
# Generate it with: 
# 1) Go to blocks folder (e.g. /home/gravium/.gravium/blocks
# 2) Execute after sync: #cat blk000*.dat > bootstrap.dat
#
#printf "** Downloading bootstrap file ***\n"
#cd /home/gravium/.gravium/
#if [ ! -d /home/gravium/.gravium/blocks ] && [ "$(curl -Is https://gravium.io/${BOOTSTRAP} | head -n 1 | tr -d '\r\n')" = "HTTP/1.1 200 OK" ] ; then \
#        sudo -u gravium wget https://gravium.io/${BOOTSTRAP}; \
#        sudo -u gravium tar -xvzf ${BOOTSTRAP}; \
#        sudo -u gravium rm ${BOOTSTRAP}; \
#fi

#
# Starting Gravium Service
#
# Hint: docker not supported systemd, use of supervisord
printf "*** Starting Gravium Service ***\n"
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
