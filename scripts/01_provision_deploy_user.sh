#!/bin/bash
set -x

# Installing SSH key
sudo mkdir -p /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh
sudo cp /tmp/deploy.pub /home/deploy/.ssh/authorized_keys
sudo chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown -R deploy /home/deploy/.ssh
sudo usermod --shell /bin/bash deploy
