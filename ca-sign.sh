#!/bin/bash

. util/welcome.sh

echo 'Will sign a certificate signing request.'

echo 'Checking...'

if [[ ! -e ca/req.csr ]]; then
  echo 'ERROR: No certificate signing request to sign'
  echo 'Please make sure the request is placed at ./ca/req.csr'
  exit 1
fi

if [[ -e ca/req.crt ]]; then
  echo 'ERROR: Just signed a certificate'
  echo 'If another certificate needs to be signed, remove the previous one at ./ca/req.crt'
  exit 1
fi

INFO=$(./view-req.sh ca/req.csr)

if [[ $INFO == *'CA:TRUE'* ]]; then
  echo 'Denying request wanting to become a CA'
  exit 1
fi

if [[ $INFO == *'Certificate Sign'* ]]; then
  echo 'Denying request wanting "Certificate Sign" privileges'
  exit 1
fi

if [[ $INFO == *'CRL Sign'* ]]; then
  echo 'Denying request wanting "CRL Sign" privileges'
  exit 1
fi

echo 'Prompting and Signing request...'
util/casign.sh ca/root.conf ca/req.csr ca/req.crt

echo 'Saving a copy of the signed certificate...'
NUM=$(find ca/certs/ ! -path ca/certs/ -printf a | wc -c)
cp ca/req.crt 'ca/certs/req'"$NUM"'.crt'

echo 'Removing OpenSSL backup files...'
rm ca/newcerts/*.pem
rm ca/*.old

echo
echo 'Review the ./ca/req.crt file'
echo 'Then send it back to the requester when ready'
echo 'If using a local CA, ./ca-respond.sh can be used'
echo
echo 'Signed!'
