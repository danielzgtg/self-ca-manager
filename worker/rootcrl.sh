#!/bin/bash
set -e

if [[ $# -ne 0 ]]; then
  echo 'Didn'\''t expect arguments'
  exit 1
fi

echo 'Generating root CA CRL...'
plumbing/gencrl.sh ca/root/ca.conf ca/root/ca.crl

exit 0
