#! /usr/bin/env bash

curl -O https://releases.hashicorp.com/packer/1.7.8/packer_1.7.8_linux_amd64.zip
mkdir ~/packer/1.7.8/
unzip packer_1.7.8_linux_amd64.zip -d ~/packer/1.7.8/
ln -s ~/paker/1.7.8/paker /usr/local/bin/paker