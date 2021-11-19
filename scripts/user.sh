#! /usr/bin/env bash

HOMEDIR=${HOME:-/home/$SSH_USERNAME}

# Make sure the home directory of the user is owned by the user
chown -R ${SSH_USERNAME}:${SSH_USERNAME} /home/${SSH_USERNAME}