#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

if [[ -d ca/intermediate ]]; then
  echo 'Rotating out old intermediate CA...'
  mv -f ca/intermediate/ ca/intermediate_old/
fi

echo 'Inflating intermediate CA...'
cp -r ca/intermediate_init/ ca/intermediate/

echo 'Picking intermediate CA key...'
plumbing/genkey.sh ca/intermediate/ca.key

echo 'Making intermediate CA request...'
plumbing/request.sh ca/intermediate/init_req.conf ca/intermediate/ca.key ca/intermediate/ca.csr

echo 'Signing intermediate CA certificate...'
plumbing/casign.sh -y ca/root/ca.conf ca/intermediate/ca.csr ca/intermediate/ca.crt
cp -fT ca/intermediate/ca.crt ca/www/chain.crt

worker/intermediatecrl.sh

exit 0
