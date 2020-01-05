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

echo 'Will make a certificate signing request.'
echo 'This will REPLACE your key!'

TYPE=$(cat req/type.txt)
SAN=$(cat identity/subject_alternative_names.conf)

if [[ "$TYPE" == 'custom' ]] && [[ ! -f req/custom_exts.conf ]]; then
  echo 'You need to specify custom extensions in ./req/custom_exts.conf'
  exit 1
fi

worker/prompt.sh

cp -Tf req/req.conf req/req_actual.conf

if [[ "$TYPE" == 'custom' ]]; then
  cat req/custom_exts.conf >> req/req_actual.conf
fi

if [[ -n "$SAN" ]]; then
  printf 'subjectAltName = @san\n[ san ]\n%s\n' "$SAN" >> req/req_actual.conf
fi

declare -a ARGS=(req/req.key)
if [[ $AES -ne 0 ]]; then
  ARGS=(-noaes "${ARGS[@]}")
fi
plumbing/genkey.sh "${ARGS[@]}"

plumbing/request.sh req/req_actual.conf req/req.key req/req.csr "$TYPE"

echo
echo 'Review the ./req/req.csr file'
if [[ "$TYPE" == 'custom' ]]; then
  echo 'Then send it to the CA once ready, together with ./req/custom_exts.conf'
else
  echo 'Then send it to the CA once ready'
fi
if [[ -n "$SAN" ]]; then
  echo 'You will also need to send them ./identity/subject_alternative_names.conf'
fi
echo 'If using a local CA, ./req-send.sh can be used'
echo 'Now wait for the CA to respond and place the signed certificate at ./req/req.crt'
echo
echo 'Setup done!'

exit 0
