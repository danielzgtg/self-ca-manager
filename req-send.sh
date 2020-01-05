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

cp -T req/req.csr ca/req.csr
cp -fT identity/subject_alternative_names.conf ca/subject_alternative_names.conf

echo
echo 'Next, use ./ca-sign.sh (generic)'
echo
echo 'Copied!'

exit 0
