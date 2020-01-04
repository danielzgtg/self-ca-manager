#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will bundle the key and certificate.'

echo 'Checking...'

if ! openssl rsa -in req/req.key -noout; then
  echo 'ERROR: Missing the private key'
  echo 'Make sure ./req-setup.sh was run'
  exit 1
fi

worker/verify.sh ./req/root.crt ./req/chain.crt ./req/req.crt

echo 'Setting dhparams...'

openssl dhparam -2 -out req/dhparams.pem

echo 'Concatenating everything together...'

cat req/req.key req/req.crt req/chain.crt req/root.crt req/dhparams.pem > req/req.pem

echo
echo 'The cryptography data at ./req/req.pem is bundled, signed, and ready to use.'
echo
echo 'Bundled!'
