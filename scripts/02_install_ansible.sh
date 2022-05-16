#!/bin/bash -eux

# Install Ansible dependencies.
sudo apt -y update && sudo apt-get -y upgrade
# sudo apt -y install python3-pip python3-dev
sudo apt -y install ansible

# Install Ansible.
# pip3 install ansible