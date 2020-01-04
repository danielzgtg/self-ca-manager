#!/bin/bash
set -e

if [[ $# -ne 0 ]]; then
  echo 'Didn'\''t expect arguments'
  exit 1
fi

echo 'Generating intermediate CA CRL...'
plumbing/gencrl.sh ca/intermediate/ca.conf ca/intermediate/ca.crl

exit 0
