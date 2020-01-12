#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

echo 'Will transfer the certificate request locally.'

if [[ -e ca/req.csr ]]; then
  echo 'WARNING: The local CA already has a request in its queue'
  worker/prompt.sh
  unlink ca/req.csr
  rm -f ca/req.crt
fi

echo 'Copying the request...'

cp -T req/req.csr ca/req.csr
cp -fT identity/subject_alternative_names.conf ca/subject_alternative_names.conf

echo
echo 'Next, use "./self-ca-manager ca sign (generic)"'
echo
echo 'Copied!'

exit 0
