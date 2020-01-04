#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will set up the CA.'
echo 'This will REPLACE the CA key!'

worker/prompt.sh

echo 'Picking root CA key...'
plumbing/genkey.sh ca/root/ca.key

echo 'Self-signing root CA...'
plumbing/selfcert.sh ca/root/init_req.conf ca/root/ca.key ca/root/ca.crt

worker/rootcrl.sh

worker/intermediate.sh

worker/cacleanup.sh

echo
echo 'Now wait for certificate requests and place the request at ./ca/req.csr'
echo 'Then run ./ca-sign.sh'
echo
echo 'Setup done!'
