#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 /etc/hosts blacklist
if [[ ! -f "/etc/hosts_permanent" ]]; then
    H3 "Copying /etc/hosts to /etc/hosts_permanent"
    sudo cp /etc/hosts /etc/hosts_permanent
fi
H2 "Scheduling daily execution via launchd (logging to /var/log/hosts-update.log)"
if [[ $(sudo launchctl list | grep com.github.themand.macos-bootstrap.hosts-update) && -f "/Library/LaunchDaemons/com.github.themand.macos-bootstrap.hosts-update.plist" ]]; then
    H3 "Stopping already running launch agent"
    sudo launchctl unload /Library/LaunchDaemons/com.github.themand.macos-bootstrap.hosts-update.plist
fi
sudo cp ${0%/*}/../scripts/assets/hosts-update/com.github.themand.macos-bootstrap.hosts-update.plist /Library/LaunchDaemons/
sudo launchctl load /Library/LaunchDaemons/com.github.themand.macos-bootstrap.hosts-update.plist
H3 OK
