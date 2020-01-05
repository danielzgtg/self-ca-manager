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
cp -ft req/ ca/www/*.crt
cp -ft req/ ca/www/*.crl.pem

echo
echo 'Next, use ./req-bundle.sh'
echo
echo 'Copied!'

exit 0
