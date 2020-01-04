#!/bin/bash

. worker/welcome.sh

echo 'Will bundle the key and certificate.'

echo 'Checking...'

if ! openssl rsa -in ./req/req.key -noout; then
  echo 'ERROR: Missing the private key'
  echo 'Make sure ./req-setup.sh was run'
  exit 1
fi

if ! openssl x509 -in ./req/req.crt -noout; then
  echo 'ERROR: Missing the signed certificate'
  echo 'Please ask the CA for one with the request and place it at ./req/req.crt'
  exit 1
fi

echo 'Setting dhparams...'

openssl dhparam -2 -out ./req/dhparams.pem

echo 'Concatenating all three together...'

cat ./req/req.key ./req/req.crt ./req/dhparams.pem > ./req/req.pem

echo
echo 'The cryptography data at ./req/req.pem is bundled, signed, and ready to use.'
echo
echo 'Bundled!'
