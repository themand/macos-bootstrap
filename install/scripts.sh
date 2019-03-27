#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "Installing custom scripts"
sudo mkdir -p /usr/local/bin

${0%/*}/script-hosts-update.sh || err
${0%/*}/script-chrome-autoconfig.sh || err
${0%/*}/script-shamir-sharing.sh || err
${0%/*}/script-genusername.sh || err

sudo -K