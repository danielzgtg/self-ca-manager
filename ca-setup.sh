#!/bin/bash

. util/welcome.sh

echo 'Will set up the CA.'
echo 'This will REPLACE the CA key!'

. util/prompt.sh

echo 'Generating root CA key...'
util/genkey.sh ca/root.key

echo 'Self-signing root CA...'
util/selfcert.sh ca/root_init_req.conf ca/root.key ca/root.crt

echo 'Generating intermediate CA key...'
util/genkey.sh ca/intermediate.key

echo 'Generating intermediate CA request...'
util/request.sh ca/intermediate_init_req.conf ca/intermediate.key ca/intermediate.csr

echo 'Signing intermediate CA certificate...'
util/casign.sh -y ca/root.conf ca/intermediate.csr ca/intermediate.crt

util/cacleanup.sh

echo
echo 'Now wait for certificate requests and place the request at ./ca/req.csr'
echo 'Then run ./ca-sign.sh'
echo
echo 'Setup done!'
