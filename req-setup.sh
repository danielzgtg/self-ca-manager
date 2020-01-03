#!/bin/bash

. util/welcome.sh

echo 'Will make a certificate signing request.'
echo 'This will REPLACE your key!'

. util/prompt.sh

util/genkey.sh req/req.key
util/request.sh req/req.conf req/req.key req/req.csr

echo
echo 'Review the ./req/req.csr file'
echo 'Then send it to the CA once ready'
echo 'If using a local CA, ./req-send.sh can be used'
echo 'Now wait for the CA to respond and place the signed certificate at ./req/req.crt'
echo
echo 'Setup done!'
