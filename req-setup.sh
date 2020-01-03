#!/bin/bash

. util/welcome.sh

echo 'Will make a certificate signing request.'
echo 'This will REPLACE your key!'

. util/prompt.sh

util/genkey.sh req/req.key
util/request.sh req/req.conf req/req.key req/req.csr

echo 'Setup done!'
