#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

echo 'Generating intermediate CA CRL...'
plumbing/gencrl.sh ca/intermediate/ca.conf ca/intermediate/ca.crl

exit 0
