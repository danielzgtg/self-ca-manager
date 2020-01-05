#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'CA type' -- "$@"

echo 'Generating '"$1"' CA CRL...'
plumbing/gencrl.sh ca/"$1"/ca.conf ca/"$1"/ca.crl

echo 'Achiving a copy of the CRL...'
NUM=$(( 0x$(cat ca/"$1"/crl.srl) - 1 ))
cp -T ca/"$1"/ca.crl ca/"$1"/crl/'ca'"$NUM"'.crl'

echo 'Publishing '"$1"' CA CRL...'
case "$1" in
  'root')
    cp -fT ca/root/ca.crl ca/www/root.crl
    cp -fT ca/root/ca.crl.pem ca/www/root.crl.pem
    ;;
  'intermediate')
    cp -fT ca/intermediate/ca.crl ca/www/chain.crl
    cp -fT ca/intermediate/ca.crl.pem ca/www/chain.crl.pem
    ;;
  *)
    echo 'WARNING: Don'\''t know where to publish the certificate, skipping'
    ;;
esac

exit 0
