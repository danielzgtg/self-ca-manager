#!/bin/bash

. util/welcome.sh

echo 'Will set up the CA.'
echo 'This will REPLACE the CA key!'

. util/prompt.sh

echo 'Generating root CA key...'
util/genkey.sh ca/root.key

echo 'Self-signing root CA...'
util/selfcert.sh ca/root_init_req.conf ca/root.key ca/root.crt

echo
echo 'Now wait for certificate requests and place the request at ./ca/req.csr'
echo 'Then run ./ca-sign.sh'
echo
echo 'Setup done!'
