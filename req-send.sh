#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will transfer the certificate request locally.'

if [[ -e ca/req.csr ]]; then
  echo 'ERROR: The local CA already has a request in its queue'
  exit 1
fi

echo 'Copying the request...'

cp req/req.csr ca/

echo
echo 'Next, use ./ca-sign.sh (generic)'
echo
echo 'Copied!'

exit 0
