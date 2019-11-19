#!/usr/bin/env bash

apt -y update
apt -y upgrade

# install python3
apt-get install python-dev python3-pip3 -q -y
pip install pathos

