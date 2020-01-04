#!/bin/bash

. worker/welcome.sh

echo 'Will transfer back the signed certificate locally.'

if [[ -e req/req.crt ]]; then
  echo 'ERROR: The local requester already has a response in its queue'
  exit 1
fi

echo 'Copying the response...'

cp ca/req.crt req/

echo
echo 'Next, use ./req-bundle.sh'
echo
echo 'Copied!'
