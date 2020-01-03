#!/bin/bash

. util/welcome.sh

echo 'Will configure the CA.'
echo 'This will RESET the ./ca/ folder!'

. util/prompt.sh

echo 'Copying files...'

mkdir -p ca
rm -rf ca/*

mkdir ca/newcerts
mkdir ca/certs
mkdir ca/crl

cp -r default_ca/* ca/
unlink ca/README.MD

cat identity/identity.conf >> ca/ca_self_init_req.conf

echo
echo 'Make changes to the .conf files in the ./ca/ folder if necessary'
echo 'Then run ./ca-setup.sh'
echo
echo 'Configured!'
