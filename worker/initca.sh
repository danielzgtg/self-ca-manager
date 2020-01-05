#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" '-noaes' 'CA type' 'parent CA type' -- "$@"

if [[ "$1" == '-noaes' ]]; then
  AES=1
  shift
else
  AES=0
fi

echo 'Picking '"$1"' CA key...'
declare -a ARGS=(ca/"$1"/ca.key)
if [[ $AES -ne 0 ]]; then
  ARGS=(-noaes "${ARGS[@]}")
fi
plumbing/genkey.sh "${ARGS[@]}"

if [[ "$1" == "$2" ]]; then
  echo 'Making '"$1"' CA self-request...'
  plumbing/request.sh ca/"$1"/init_req.conf ca/"$1"/ca.key ca/"$1"/ca.csr bootstrap

  echo 'Self-signing '"$1"' CA certificate...'
  plumbing/selfcert.sh ca/"$1"/ca.conf ca/"$1"/ca.csr ca/"$1"/ca.crt
else
  echo 'Making '"$1"' CA request...'
  plumbing/request.sh ca/"$1"/init_req.conf ca/"$1"/ca.key ca/"$1"/ca.csr init

  echo 'Signing '"$1"' CA certificate...'
  plumbing/casign.sh -y ca/"$2"/ca.conf ca/"$1"/ca.csr ca/"$1"/ca.crt init
fi

echo 'Publishing '"$1"' CA certificate...'
case "$1" in
  'root')
    cp -fT ca/root/ca.crt ca/www/root.crt
    ;;
  'intermediate')
    cp -fT ca/intermediate/ca.crt ca/www/chain.crt
    ;;
  *)
    echo 'WARNING: Don'\''t know where to publish the certificate, skipping'
    ;;
esac

ARGS=("$1")
if [[ $AES -ne 0 ]]; then
  ARGS=(-noaes "${ARGS[@]}")
fi
worker/initocsp.sh "${ARGS[@]}"

exit 0
