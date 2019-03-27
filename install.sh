#!/usr/bin/env bash

set -euo pipefail

. ${0%/*}/includes/functions.sh

H1 "This is post-bootstrap, which will install lot of 3rd party tools"
yesno "Did you already finished bootstrap?"
if ! $YESNO; then
    H1 "Bootstrap-install aborted"
    exit 1
fi

H2WARN "It's best to have firewall enabled in monitoring/restrictive mode during this step"
noyes "Do you have firewall enabled and want to start?"

if ! $YESNO; then
    H1 "Bootstrap-install aborted"
    exit 1
fi

${0%/*}/install/brew.sh || err
${0%/*}/install/hosts.sh || err
${0%/*}/install/scripts.sh || err
sudo -K
${0%/*}/install/brew-formulas.sh || err

H1 "Bootstrap-install finished!"
