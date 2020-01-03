#!/bin/bash

. util/welcome.sh

echo 'Will set up the CA.'
echo 'This will REPLACE the CA key!'

. util/prompt.sh

util/genkey.sh ca/ca.key
util/selfcert.sh ca/ca_self_init_req.conf ca/ca.key ca/ca.crt

echo 'Setup done!'
