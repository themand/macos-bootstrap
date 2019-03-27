#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2 "shamir-sharing"
SHAMIR_TMPDIR="${TMPDIR}$(uuidgen)"
mkdir -p $SHAMIR_TMPDIR
H3 "Downloading..."
curl -sSL -o ${SHAMIR_TMPDIR}/macos-shamir-split https://github.com/themand/shamir-sharing/releases/download/v1.0.0/macos-shamir-split
curl -sSL -o ${SHAMIR_TMPDIR}/macos-shamir-combine https://github.com/themand/shamir-sharing/releases/download/v1.0.0/macos-shamir-combine
H3 "Verifying checksums..."
SHAMIR_VALID_SPLIT="14e888964e176040047173debbd60b272a028759e19cd59218671ef7c2c85b24"
SHAMIR_VALID_COMBINE="bf84bd196099b3733d36c30b27940d7da255f7c81487bbed7c67b497135dc05c"
SHAMIR_SHA_SPLIT=$(shasum -p -a 256 $SHAMIR_TMPDIR/macos-shamir-split | cut -d' ' -f1)
SHAMIR_SHA_COMBINE=$(shasum -p -a 256 $SHAMIR_TMPDIR/macos-shamir-combine | cut -d' ' -f1)
if [[ "$SHAMIR_SHA_SPLIT" == "$SHAMIR_VALID_SPLIT" ]] \
&& [[ "$SHAMIR_SHA_COMBINE" == "$SHAMIR_VALID_COMBINE" ]]; then
    H3 "Installing..."
    sudo mv ${SHAMIR_TMPDIR}/macos-shamir-split /usr/local/bin/shamir-split
    sudo mv ${SHAMIR_TMPDIR}/macos-shamir-combine /usr/local/bin/shamir-combine
    sudo chmod +x /usr/local/bin/shamir-split /usr/local/bin/shamir-combine
else
    H2WARN "Checksums invalid. Not installing. Deleting downloaded files"
    H3 "macos-shamir-split downloaded sha256   : ${SHAMIR_SHA_SPLIT}"
    H3 "macos-shamir-split valid sha256        : ${SHAMIR_VALID_SPLIT}"
    H3 "macos-shamir-combine downloaded sha256 : ${SHAMIR_SHA_COMBINE}"
    H3 "macos-shamir-combine valid sha256      : ${SHAMIR_VALID_COMBINE}"
fi
rm -R "$SHAMIR_TMPDIR"
