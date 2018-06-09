# Gravium (GRV) Masternode - Dockerfile (06-2018)
#
# The Dockerfile will install all required stuff to run a Gravium (GRV) Masternode and based on the script gravium_masternode.sh (see: https://github.com/Gravium/gravium-docs/scripts/gravium_masternode.sh)
# Gravium Repo : https://github.com/Gravium
# 
# To build a docker image for grv-masternode from the Dockerfile the gravium.conf is also needed.
# See BUILD_README.md for further steps.

# Use an official Ubuntu runtime as a parent image
FROM ubuntu:16.04

LABEL maintainer="David B. (dalijolijo)"
LABEL version="0.1"

# Make ports available to the world outside this container
# DefaultPort = 11000
# RPCPort = 11010
EXPOSE 11000 11010

USER root

# Change sh to bash
SHELL ["/bin/bash", "-c"]

# Define environment variable
ENV GRAVPWD "gravium"

RUN echo '*** Gravium (GRV) Masternode ***'

#
# Creating gravium user
#
RUN echo '*** Creating gravium user ***' && \
    adduser --disabled-password --gecos "" gravium && \
    usermod -a -G sudo,gravium gravium && \
    echo gravium:$GRVPWD | chpasswd

#
# Running updates and installing required packages
#
#
RUN echo '*** Running updates and installing required packages ***' && \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  apt-utils \
                        autoconf \
                        automake \
                        autotools-dev \
                        build-essential \
                        curl \
                        git \
                        libboost-all-dev \
                        libevent-dev \
                        libminiupnpc-dev \
                        libssl-dev \
                        libtool \
                        libzmq5-dev \
                        pkg-config \
                        software-properties-common \
                        sudo \
                        supervisor \
                        vim \
                        wget && \
    add-apt-repository -y ppa:bitcoin/bitcoin && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y  libdb4.8-dev \
                        libdb4.8++-dev

#
# Cloning and Compiling Gravium Wallet
#
RUN echo '*** Cloning and Compiling Gravium Wallet ***' && \
    cd && \
    echo "Execute a git clone of Gravium. Please wait..." && \
    git clone https://github.com/Gravium/gravium.git && \
    cd Gravium && \
    ./autogen.sh && \
    ./configure --disable-dependency-tracking --enable-tests=no --without-gui && \
    make && \
    cd && \
    cd Gravium/src && \
    strip graviumd && \
    cp graviumd /usr/local/bin && \
    strip gravium-cli && \
    cp gravium-cli /usr/local/bin && \
    strip gravium-tx && \
    cp gravium-tx /usr/local/bin && \
    chmod 775 /usr/local/bin/graviumd* && \   
    cd && \
    rm -rf Gravium

#
# Copy Supervisor Configuration and gravium.conf
#
RUN echo '*** Copy Supervisor Configuration and gravium.conf ***'
COPY *.sv.conf /etc/supervisor/conf.d/
COPY gravium.conf /tmp

#
# Logging outside docker container
#
VOLUME /var/log

#
# Start script
#
RUN echo '*** Copy start script ***'
COPY start.sh /usr/local/bin/start.sh
RUN rm -f /var/log/access.log && mkfifo -m 0666 /var/log/access.log && \
    chmod 755 /usr/local/bin/*

ENV TERM linux
CMD ["/usr/local/bin/start.sh"]
