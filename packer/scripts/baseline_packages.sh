#!/bin/bash
#echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
# sudo apt update -y
# sudo apt install nginx -y
# sudo apt install docker -y

sudo echo "public_key" >> /home/ubuntu/.ssh/authorized_keys
