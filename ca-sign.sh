#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'extension profile' -- "$@"

worker/welcome.sh

echo 'Will sign a certificate signing request for profile "'"$1"'"'

case "$1" in
  'generic')
    # OK
    ;;
  'bootstrap'|'init'|'ocsp')
    echo 'ERROR: Specified extension profile is for private internal use'
    echo 'Signing such a request would grant the requester all privileges that you have'
    exit 1
    ;;
  *)
    echo 'ERROR: Unknown extension profile specified'
    echo 'Please examine the extensions in the requester'\''s signing request to determine which profile they want'
    echo 'If the requester didn'\''t specify any extensions, then they probably want "generic"'
    exit 1
    ;;
esac

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
plumbing/casign.sh ca/intermediate/ca.conf ca/req.csr ca/req.crt "$1"

worker/gencrl.sh intermediate

echo 'Saving a copy of the signed certificate...'
CERTS_DIR=ca/intermediate/certs/
NUM=$(find "$CERTS_DIR" ! -path "$CERTS_DIR" -printf a | wc -c)
cp ca/req.crt "$CERTS_DIR"'req'"$NUM"'.crt'

worker/cacleanup.sh

echo
echo 'Review the ./ca/req.crt file'
echo 'Then send it back to the requester when ready'
echo 'If using a local CA, ./ca-respond.sh can be used'
echo
echo 'Signed!'

exit 0
