#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" '-noaes' -- "$@"

if [[ "$1" == '-noaes' ]]; then
  AES=1
  shift
else
  AES=0
fi

worker/welcome.sh

echo 'Will set up the CA.'
echo 'This will REPLACE the CA key!'

worker/prompt.sh

declare -a ARGS=(root root)
if [[ $AES -ne 0 ]]; then
  ARGS=(-noaes "${ARGS[@]}")
fi
worker/initca.sh "${ARGS[@]}"

ARGS=(-noaes)
if [[ $AES -eq 0 ]]; then
  ARGS=()
fi
worker/intermediate.sh "${ARGS[@]}"

worker/cacleanup.sh

echo
echo 'Now wait for certificate requests and place the request at ./ca/req.csr'
echo 'Then run ./ca-sign.sh'
echo
echo 'Setup done!'

exit 0
