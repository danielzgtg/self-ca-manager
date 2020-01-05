#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'CA type' 'bind authority' -- "$@"

worker/welcome.sh

echo 'Will a OCSP responder for the '"$1"' CA'
echo 'WARNING: The OpenSSL implementation is for testing only. Please use a real OCSP responder for production'

worker/prompt.sh

cd ca/"$1"

exec openssl ocsp -url http://"$2"/ -text -index index.txt -CA ca.crt -rkey ocsp.key -rsigner ocsp.crt
