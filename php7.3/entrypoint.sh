#!/bin/bash

# separate nvm data from nvm itself
export NVM_DIR="/var/www/nvm-volume"
[ -s "/var/www/.nvm/nvm.sh" ] && . "/var/www/.nvm/nvm.sh"

# run the command
eval "$@"
