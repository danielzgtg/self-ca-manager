#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'input root cert path' 'input cert chain path' 'input cert path' -- "$@"

if ! openssl x509 -in req/root.crt -noout; then
  echo 'ERROR: Missing the CA root certificate'
  echo 'Please ask the CA for their root certificate and place it at '"$1"
  exit 1
fi

if ! openssl x509 -in req/chain.crt -noout; then
  echo 'ERROR: Missing the CA certificate chain'
  echo 'Please ask the CA for their certificate chain and place it at '"$2"
  exit 1
fi

if ! openssl x509 -in req/req.crt -noout; then
  echo 'ERROR: Missing the signed certificate'
  echo 'Please ask the CA for one with the request and place it at '"$3"
  exit 1
fi

if ! openssl verify -CAfile "$1" "$2"; then
  echo 'ERROR: The CA certificate chain at '"$2"' is invalid!'
  echo 'Please ask the CA for an updated certificate chain'
  exit 1
fi

if ! openssl verify -CAfile "$1" -untrusted "$2" "$3"; then
  echo 'ERROR: The signed certificate at '"$3"' is invalid!'
  echo 'Please ask the CA to sign another certificate'
  exit 1
fi

echo 'The signed certificate is vaild'

exit 0
