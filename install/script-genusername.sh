#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2 "genusername"
USERGEN_TMPDIR="${TMPDIR}$(uuidgen)"
mkdir -p "$USERGEN_TMPDIR"
H3 "Downloading..."
curl -sSL -o ${USERGEN_TMPDIR}/genusername.js https://raw.githubusercontent.com/themand/genusername/master/genusername.js
H3 "Verifying checksum..."
USERGEN_VALID="6992dde02d43bb03327d0f0baab77d59cae7362abafec852963ec3334005db40"
USERGEN_SHA=$(shasum -p -a 256 $USERGEN_TMPDIR/genusername.js | cut -d' ' -f1)
if [[ "$USERGEN_SHA" == "$USERGEN_VALID" ]]; then
    H3 "Installing..."
    (
        echo '#!/usr/local/bin/node'
        cat "$USERGEN_TMPDIR"/genusername.js
    ) | sudo tee /usr/local/bin/genusername > /dev/null
    sudo chmod +x /usr/local/bin/genusername
else
    H2WARN "Checksums invalid. Not installing. Deleting downloaded files"
    H3 "genusername.js downloaded sha256   : ${USERGEN_SHA}"
    H3 "genusername.js valid sha256        : ${USERGEN_VALID}"
fi
rm -R "$USERGEN_TMPDIR"
