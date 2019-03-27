#!/usr/bin/env bash

set -euo pipefail

. ${0%/*}/includes/functions.sh

H1 "This script will configure your macOS and install development tools."
yesno "Do you want to start?"

if ! $YESNO; then
    H1 "Bootstrap aborted"
    exit 1
fi

${0%/*}/bootstrap/macos.sh || err
${0%/*}/bootstrap/dotfiles.sh || err
${0%/*}/bootstrap/filevault.sh || err

H1 "Bootstrap finished!"
H1 "System restart recommended"
