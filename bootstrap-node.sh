#!/usr/bin/env bash

# bootstrap script for the external services simulation machine

# enable output what is executed:
set -x

MACHINE=$1

SCRIPTPATH="/vagrant"
MACHINE_PATH="$SCRIPTPATH/machines/${MACHINE}/"
#mkdir -p "$MACHINE_PATH"
#cd "$MACHINE_PATH"

#mkdir -p /home/vagrant
echo 'vagrant:x:130:130::/home/vagrant:/bin/ash'>>/etc/passwd