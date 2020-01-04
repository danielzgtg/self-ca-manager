#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'output CRL path' -- "$@"

if [[ $# -ne 2 ]]; then
  echo 'Expecting 2 arguments: "config path" "output CRL path"'
  exit 1
fi

openssl ca -gencrl -config "$1" -out "$2"'.pem'
openssl crl -inform PEM -in "$2"'.pem' -outform DER -out "$2"

exit 0
