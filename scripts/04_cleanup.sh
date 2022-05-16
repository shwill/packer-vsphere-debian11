#!/bin/bash -eux

## Uninstall Ansible and dependencies.
#pip3 uninstall ansible
#apt-get remove python3-pip python3-dev
sudo apt remove ansible -y

# Apt cleanup.
sudo apt autoremove -y
sudo apt update

#  Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id