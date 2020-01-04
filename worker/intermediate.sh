#!/bin/bash
set -e

if [[ $# -ne 0 ]]; then
  echo 'Didn'\''t expect arguments'
  exit 1
fi

echo 'Picking intermediate CA key...'
plumbing/genkey.sh ca/intermediate.key

echo 'Making intermediate CA request...'
plumbing/request.sh ca/intermediate_init_req.conf ca/intermediate.key ca/intermediate.csr

echo 'Signing intermediate CA certificate...'
plumbing/casign.sh -y ca/root.conf ca/intermediate.csr ca/intermediate.crt

echo 'Generating intermediate CA CRL...'
plumbing/gencrl.sh ca/intermediate.conf ca/intermediate.crl

exit 0
