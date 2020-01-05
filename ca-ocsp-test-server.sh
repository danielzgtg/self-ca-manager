#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" '-1' 'CA type' 'bind authority' -- "$@"

if [[ "$1" == '-1' ]]; then
  shift
  ONCE=0
else
  ONCE=1
fi

worker/welcome.sh

echo 'Will a OCSP responder for the '"$1"' CA'
echo 'WARNING: The OpenSSL implementation is for testing only. Please use a real OCSP responder for production'

worker/prompt.sh

declare -a ARGS=(-url http://"$2"/ -text -index index.txt -CA ca.crt -rkey ocsp.key -rsigner ocsp.crt)
if [[ $ONCE -eq 0 ]]; then
  ARGS+=(-nrequest 1)
fi

cd ca/"$1"
exec openssl ocsp "${ARGS[@]}"
