#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'CA type' -- "$@"

echo 'Generating '"$1"' CA CRL...'
plumbing/gencrl.sh ca/"$1"/ca.conf ca/"$1"/ca.crl

echo 'Achiving a copy of the CRL...'
CRL_DIR=ca/"$1"/crl/
NUM=$(find "$CRL_DIR" ! -path "$CRL_DIR" -printf a | wc -c)
set -x
cp -T ca/"$1"/ca.crl "$CRL_DIR"'ca'"$NUM"'.crl'
set +x

echo 'Publishing '"$1"' CA CRL...'
case "$1" in
  'root')
    cp -fT ca/root/ca.crl ca/www/root.crl
    ;;
  'intermediate')
    cp -fT ca/intermediate/ca.crl ca/www/chain.crl
    ;;
  *)
    echo 'WARNING: Don'\''t know where to publish the certificate, skipping'
    ;;
esac

exit 0
