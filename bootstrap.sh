#!/usr/bin/env bash
set -ex

## Don't run twice for development
if [ -d /opt/lw1 ]; then exit ; fi

## for HVM work around from ubuntu forum https://bugs.launchpad.net/cloud-init/+bug/1309079
sudo rm /boot/grub/menu.lst
sudo update-grub-legacy-ec2 -y
sudo apt-get -y update
echo grub-pc grub-pc/install_devices_disks_changed select /dev/xvda | sudo debconf-set-selections
echo grub-pc grub-pc/install_devices select /dev/xvda | sudo  debconf-set-selections
DEBIAN_FRONTEND=noninteractive sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y upgrade
sudo apt-get -y update

## Install Chef-Client
curl -L https://www.getchef.com/chef/install.sh | sudo bash

## Setup hint for ec2
sudo mkdir -p /etc/chef/ohai/hints
sudo touch /etc/chef/ohai/hints/ec2.json
echo '{}' > ./ec2.json
sudo mv ./ec2.json /etc/chef/ohai/hints/ec2.json
sudo chown root.root /etc/chef/ohai/hints/ec2.json

## Fine
sudo install -o root -g root -d /opt/lw1
