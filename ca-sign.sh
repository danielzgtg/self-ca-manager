#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'extension profile' -- "$@"

worker/welcome.sh

echo 'Will sign a certificate signing request for profile "'"$1"'"'

case "$1" in
  'generic')
    # OK
    ;;
  'custom')
    if [[ ! -f ca/custom_exts.conf ]]; then
      echo 'Please place the requester'\''s custom extensions in ./ca/custom_exts.conf'
      exit 1
    fi
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

restrict-privilege() {
  # $1 - Privilege name

  if [[ $INFO == *"$1"* ]]; then
    echo 'Denying request wanting "'"$1"'" privileges'
    exit 1
  fi
}

restrict-privilege 'Certificate Sign'
restrict-privilege 'CRL Sign'
restrict-privilege 'OCSP Signing'

SAN=$(cat ca/subject_alternative_names.conf)
ORIGINAL=$(cat ca/intermediate/ca.conf)

if [[ -n "$SAN" ]]; then
  printf '%s\n[ san ]\n%s\n' "${ORIGINAL//#subjectAltName = @san/subjectAltName = @san}" "$SAN" \
    > ca/intermediate/ca_actual.conf
else
  echo "$ORIGINAL" > ca/intermediate/ca_actual.conf
fi

echo 'Prompting and Signing request...'
plumbing/casign.sh ca/intermediate/ca_actual.conf ca/req.csr ca/req.crt "$1"

worker/gencrl.sh intermediate

echo 'Archiving a copy of the signed certificate...'
NUM=$(( 0x$(cat ca/intermediate/ca.srl) - 1 ))
cp -T ca/req.crt ca/intermediate/certs/'req'"$NUM"'.crt'

worker/cacleanup.sh

echo
echo 'Review the ./ca/req.crt file'
echo 'Then send it back to the requester when ready'
echo 'If using a local CA, ./ca-respond.sh can be used'
echo
echo 'Signed!'

exit 0
