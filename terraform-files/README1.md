sudo vim /etc/hosts

172.31.44.65 controlplane
172.31.32.167 worker1
172.31.36.8 worker2

sudo hostnamectl set-hostname controlplane
sudo hostnamectl set-hostname worker1
sudo hostnamectl set-hostname worker2



#!/bin/bash

# Define the entries you want to add to /etc/hosts
sudo tee -a /etc/hosts << EOF
172.31.44.65  controlplane
172.31.32.167  worker1
172.31.36.8  worker2
EOF
