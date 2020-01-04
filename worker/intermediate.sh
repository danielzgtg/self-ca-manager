#!/bin/bash
set -e

if [[ $# -ne 0 ]]; then
  echo 'Didn'\''t expect arguments'
  exit 1
fi

echo 'Picking intermediate CA key...'
plumbing/genkey.sh ca/intermediate/ca.key

echo 'Making intermediate CA request...'
plumbing/request.sh ca/intermediate/init_req.conf ca/intermediate/ca.key ca/intermediate/ca.csr

echo 'Signing intermediate CA certificate...'
plumbing/casign.sh -y ca/root/ca.conf ca/intermediate/ca.csr ca/intermediate/ca.crt

echo 'Generating intermediate CA CRL...'
plumbing/gencrl.sh ca/intermediate/ca.conf ca/intermediate/ca.crl

exit 0
