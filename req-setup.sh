#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will make a certificate signing request.'
echo 'This will REPLACE your key!'

worker/prompt.sh

TYPE=$(cat req/type.txt)

plumbing/genkey.sh req/req.key
plumbing/request.sh req/req.conf req/req.key req/req.csr "$TYPE"

echo
echo 'Review the ./req/req.csr file'
if [[ "$TYPE" == 'custom' ]]; then
  echo 'Then send it to the CA once ready, together with ./req/custom_exts.conf'
else
  echo 'Then send it to the CA once ready'
fi
echo 'If using a local CA, ./req-send.sh can be used'
echo 'Now wait for the CA to respond and place the signed certificate at ./req/req.crt'
echo
echo 'Setup done!'

exit 0
