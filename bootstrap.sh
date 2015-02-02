#!/usr/bin/env bash

MACHINE=$1

# optional: if you have brances in your own repo that should be merged ad the repo here:
FFNORD_TESTING_REPO=
# and add the branches here (komma separated):
FFNORD_TESTING_BRANCHES=()

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

apt-get update
apt-get install --no-install-recommends -y puppet git tcpdump mtr-tiny
# optional apt-get install --no-install-recommends -y vim

puppet module install puppetlabs-stdlib
puppet module install puppetlabs-apt
puppet module install puppetlabs-vcsrepo

cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

if [ "x${FFNORD_TESTING_REPO}" != "x" ]; then
  cd ffnord
  git remote add testing "$FFNORD_TESTING_REPO"
  git fetch testing
  for branch in ${FFNORD_TESTING_BRANCHES[@]}; do
    git merge --no-ff "testing/${branch}"
  done
fi

cd "$MACHINE_PATH"
cp -r * /root
cd /root
puppet apply manifest.pp --verbose

cat > /etc/iptables.d/199-allow-wan << EOF
## allow all connections from wan for experimental envionments
ip46tables -A wan-input -j ACCEPT
EOF

build-firewall
service iptables-persistent save

# comment this out, if you want to keep manuals, documentation and all locales in your machines
source $SCRIPTPATH/minify_debian.sh
