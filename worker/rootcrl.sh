#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

echo 'Generating root CA CRL...'
plumbing/gencrl.sh ca/root/ca.conf ca/root/ca.crl

exit 0
