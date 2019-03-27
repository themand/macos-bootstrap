#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

reqyes() {
    noyes "Did you write down the recovery key in a secure location?"
    if [[ "$YESNO" == true ]]; then
        H3 "Great!"
    else
        H3 "You should really do it! I'll wait..."
        sleep 5
        reqyes
    fi
}

H1 "FileVault Full Disk Encryption"
if [[ $(fdesetup isactive) == "false" ]]; then
    H2WARN "Answer Y to enable encryption. Pressing RETURN will NOT enable encryption."
    H2WARN "A personal recovery key will be shown to you. You need to write it down"
    H2WARN "and store in a secure location (preferably offline)."
    H2WARN "This will be the only time you will be shown the recovery key and the recovery"
    H2WARN "key will NOT be stored anywhere. You need to write it down. You'll lose access"
    H2WARN "access to your data if you forget your password and won't have recovery key."
    noyes "Do you want to enable encryption?"
    if [[ "$YESNO" == true ]]; then
        H2 "Enabling encryption..."
        sudo fdesetup enable
        H2 "Make sure you stored the recovery key in a secure offline location."
        reqyes
        H2WARN "Encryption enabled and in progress"
    else
        H2 "Encryption will NOT be enabled"
    fi
else
    H2 "FileVault already active"
fi
