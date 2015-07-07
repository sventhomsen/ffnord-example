#!/usr/bin/env bash

# bootstrap script for the external services simulation machine

# enable output what is executed:
set -x

MACHINE=$1

SCRIPTPATH="/vagrant"
MACHINE_PATH="$SCRIPTPATH/machines/${MACHINE}/"
mkdir -p "$MACHINE_PATH"

cat > /etc/apt/sources.list << EOF
deb http://ftp.de.debian.org/debian wheezy main
deb-src http://ftp.de.debian.org/debian wheezy main

deb http://security.debian.org/ wheezy/updates main contrib
deb-src http://security.debian.org/ wheezy/updates main contrib

# wheezy-updates, previously known as 'volatile'
deb http://ftp.de.debian.org/debian wheezy-updates main contrib
deb-src http://ftp.de.debian.org/debian wheezy-updates main contrib
EOF

#Reconfigure apt so that it does not install additional packages
echo 'APT::Install-Recommends "0" ; APT::Install-Suggests "0" ; '>>/etc/apt/apt.conf

# install packages without user interaction:
export DEBIAN_FRONTEND=noninteractive

# comment this out, if you want to keep manuals, documentation and all locales in your machines
#source $SCRIPTPATH/minify_debian.sh

apt-get update
apt-get install --no-install-recommends -y \
        git tcpdump mtr-tiny unp \
        openvpn tinc iptables-persistent
# optional 
#apt-get install --no-install-recommends -y puppet vim
cd "$MACHINE_PATH"

# Setup openvpn service
cp -r openvpn /etc/openvpn/vpn-service
ln -s /etc/openvpn/vpn-service/server.conf /etc/openvpn/vpn-service.conf
service openvpn restart
update-rc.d -f openvpn defaults

# iptables
iptables -A POSTROUTING -t nat -o eth0 -j MASQUERADE
service iptables-persistent save

# sysctl settings
cp routing.conf /etc/sysctl.d/
sysctl --system

# comment this out, if you want to keep manuals, documentation and all locales in your machines
#source $SCRIPTPATH/minify_debian.sh

###### gateway testscript
cd /opt/
git clone https://github.com/rubo77/gateway-test.sh.git

: "start the testscript gc-gw0 gc-gw1 and mp-gw0"
# TODO: sed INTERFACE to eth0
#/opt/gateway-test.sh 172.19.0.1

###### Install ffmap-backend

: "install alfred-json, alfred and batadv-vis"
cat > /etc/apt/sources.list.d/draic.list << EOF
deb [arch=amd64] http://debian.draic.info/ wheezy main
deb-src http://debian.draic.info/ wheezy main
EOF
apt-get update
# install dependencies to compile alfred:
apt-get install libjansson-dev cmake fakeroot dpkg-dev build-essential zlib1g-dev pkg-config debhelper quilt
cd /tmp/
apt-get source --allow-unauthenticated alfred-json alfred
cd alfred-json-0.3.1/
dpkg-buildpackage -uc -us
cd /tmp/alfred-2014.3.0/
dpkg-buildpackage -uc -us
dpkg -i ../alfred-json_0.3.1-1_i386.deb
dpkg -i ../alfred_2014.3.0-11_i386.deb
dpkg -i ../batadv-vis_2014.3.0-11_i386.deb 
# or maybe later just
# dpkg -i /vagrant/machines/services/alfred-json_0.3.1-1_i386.deb

apt-get install rrdtool python3-pip
pip3.2 install Networkx

cd /opt/
git clone https://github.com/ffnord/ffmap-backend.git
mkdir -p /var/www/mesh/data/
python3 /opt/ffmap-backend/backend.py -d /var/www/mesh/data/
