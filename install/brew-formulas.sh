#!/usr/bin/env bash

set -euo pipefail

. ${0%/*}/../includes/functions.sh

H1 "Installing brew formulas"

brew install openssl
brew install gnupg
brew install jq

