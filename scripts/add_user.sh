#!/bin/bash
NEW_USER='roomba'
PASSWORD='S3cure'
sudo useradd -p $(openssl passwd -1 $PASSWORD) $NEW_USER
sudo usermod -aG sudo $NEW_USER
sudo echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers

