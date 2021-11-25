#! /usr/bin/env bash

DIR="/tmp/packer"
FILE="packer.zip"
mkdir -p $DIR
cd $DIR
curl -o $FILE https://releases.hashicorp.com/packer/1.7.8/packer_1.7.8_linux_amd64.zip
unzip $FILE
# ln -s ~/paker/1.7.8/paker /usr/local/bin/paker
# mv packer /usr/bin/