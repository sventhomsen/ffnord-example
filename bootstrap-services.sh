#!/usr/bin/env bash

# bootstrap script for the external services simulation machine

cat > /etc/apt/sources.list << EOF
deb http://ftp.de.debian.org/debian wheezy main
deb-src http://ftp.de.debian.org/debian wheezy main

deb http://security.debian.org/ wheezy/updates main contrib
deb-src http://security.debian.org/ wheezy/updates main contrib

# wheezy-updates, previously known as 'volatile'
deb http://ftp.de.debian.org/debian wheezy-updates main contrib
deb-src http://ftp.de.debian.org/debian wheezy-updates main contrib
EOF

apt-get update
apt-get install --no-install-recommends -y \
        puppet git tcpdump mtr-tiny vim \
        openvpn tinc iptables-persistent

cd "/vagrant/machines/services/"

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