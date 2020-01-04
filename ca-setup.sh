#!/bin/bash

. worker/welcome.sh

echo 'Will set up the CA.'
echo 'This will REPLACE the CA key!'

. worker/prompt.sh

echo 'Picking root CA key...'
plumbing/genkey.sh ca/root.key

echo 'Self-signing root CA...'
plumbing/selfcert.sh ca/root_init_req.conf ca/root.key ca/root.crt

echo 'Generating root CA CRL...'
plumbing/gencrl.sh ca/root.conf ca/root.crl

worker/intermediate.sh

worker/cacleanup.sh

echo
echo 'Now wait for certificate requests and place the request at ./ca/req.csr'
echo 'Then run ./ca-sign.sh'
echo
echo 'Setup done!'
