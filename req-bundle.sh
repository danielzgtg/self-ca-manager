#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" '-fast-testing-mode' -- "$@"

if [[ "$1" == '-fast-testing-mode' ]]; then
  FAST_TESTING_MODE=0
else
  FAST_TESTING_MODE=1
fi

if [[ $FAST_TESTING_MODE -eq 0 ]] && [[ ! -f testmode ]]; then
  echo '-fast-testing-mode may only be used when testing'
  exit 1
fi

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

if [[ $FAST_TESTING_MODE -eq 0 ]]; then
  echo 'WARNING: Using weaker params to speed up testing!!!'
  openssl dhparam -dsaparam -out req/dhparams.pem 1024
else
  openssl dhparam -2 -out req/dhparams.pem 2048
fi

echo 'Concatenating everything together...'

cat req/req.key req/req.crt req/chain.crt req/root.crt req/dhparams.pem > req/req.pem

echo
echo 'The cryptography data at ./req/req.pem is bundled, signed, and ready to use.'
echo
echo 'Bundled!'
