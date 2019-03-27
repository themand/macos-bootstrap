#!/usr/bin/env bash

set -euo pipefail

URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

err() {
    if [[ -z "${1-}" ]]; then
        MSG=""
        CODE=100
    else
        if [[ "${1}" =~ ^[0-9]+$ ]]; then
            CODE="${1}"
            shift
        else
            CODE=100
        fi
        MSG="$@"
    fi
    (>&2 echo -e $(date +%FT%T%z)"\tERROR\t $MSG")
    exit "$CODE"
}

if [[ $(whoami) != "root" ]]; then
    err 101 "hosts-update needs to be run by root"
fi

if [[ ! -f "/etc/hosts_permanent" ]]; then
    err 102 "Hosts not updated. /etc/hosts_permanent does not exists"
fi

TMPFILE="/tmp/hosts-update-$(uuidgen)"
if ! DOWNLOADED=$(curl -sS $URL 2>&1); then
    err 106 "Error downloading hosts blacklist: $DOWNLOADED"
fi
FILTERED=$(echo "$DOWNLOADED" | grep -E "^0.0.0.0|^#|^$")
(
    echo "# ==== WARNING: Do not edit hosts, as it will be overwritten soon"
    echo "# ==== Instead: Edit /etc/hosts_permanent file and then run hosts-update"
    echo "# ---------- Contents of /etc/hosts_permanent" && \
    cat /etc/hosts_permanent && \
    echo "# ---------- Blacklist from $URL" && \
    echo "$FILTERED"
) | tee $TMPFILE > /dev/null || err "$?" "Error saving temp file $TMPFILE";

mv $TMPFILE /etc/hosts || err 103 "Error replacing /etc/hosts"
dscacheutil -flushcache || err 104 "Error flushing DNS cache"
killall -HUP mDNSResponder || err 105 "Error restarting mDNSResponder"

echo -e $(date +%FT%T%z)"\tOK\tHosts updated. "$(cat /etc/hosts | wc -l | xargs)" lines in /etc/hosts"
