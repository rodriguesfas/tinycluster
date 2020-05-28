#!/usr/bin/env bash

echo "==> Update pakage.."
apt -y update && apt -y upgrade

echo "==> Install python3.."
apt-get install python3.7 python3.7-dev python3-pip -q -y

echo "Define version.."
ln -s python3 /usr/bin/python

