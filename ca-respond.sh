#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will transfer back the signed certificate locally.'

if [[ -e req/req.crt ]]; then
  echo 'ERROR: The local requester already has a response in its queue'
  exit 1
fi

echo 'Copying the response...'

cp ca/req.crt req/
cp -fT ca/root/ca.crt req/root.crt
cp -fT ca/intermediate/ca.crt req/chain.crt

echo
echo 'Next, use ./req-bundle.sh'
echo
echo 'Copied!'
