#! /usr/bin/env bash

curl -O https://releases.hashicorp.com/terraform/0.13.2/terraform_0.13.2_linux_amd64.zip
mkdir -p ~/terraform/0.13.2/
unzip terraform_0.13.2_linux_amd64.zip ~/terraform/0.13.2/
# chmod +x terraform
ln -s ~/terraform/0.13.2/terraform /usr/local/bin/terraform
