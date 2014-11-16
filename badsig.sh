#!/bin/bash

sudo apt-get clean
cd /var/lib/apt
sudo rm -rf lists.old
sudo mv lists lists.old
sudo mkdir -p lists/partial
sudo apt-get clean
sudo apt-get update
