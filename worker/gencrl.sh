#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'CA type' -- "$@"

echo 'Generating '"$1"' CA CRL...'
plumbing/gencrl.sh ca/"$1"/ca.conf ca/"$1"/ca.crl

exit 0
