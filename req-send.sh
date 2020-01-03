#!/bin/bash

. util/welcome.sh

echo 'Will transfer the certificate request locally.'

if [[ -e ca/req.csr ]]; then
  echo 'The local CA already has a request in its queue'
  exit 1
fi

echo 'Copying the request...'

cp req/req.csr ca/

echo
echo 'Next, use ./ca-sign.sh'
echo
echo 'Copied!'
