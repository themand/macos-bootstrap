#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2 "hosts-update"
H3 "Installing..."
sudo cp ${0%/*}/../scripts/hosts-update.sh /usr/local/bin/hosts-update
if [[ ! -f "/etc/hosts_permanent" ]]; then
    H3 "Copying /etc/hosts to /etc/hosts_permanent"
    sudo cp /etc/hosts /etc/hosts_permanent
fi
