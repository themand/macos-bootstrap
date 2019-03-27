#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "Installing dotfiles to home directory"
cp -r $(echo ${0%/*})/assets/dotfiles/ ~/

chmod 700 ~/.gnupg
chmod 600 ~/.gnupg/*
