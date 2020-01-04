#!/bin/bash

. worker/welcome.sh

echo 'Will configure the CA.'
echo 'This will RESET the ./ca/ folder!'

. worker/prompt.sh

echo 'Copying files...'

mkdir -p ca
rm -rf ca/*

mkdir ca/root_crl
mkdir ca/intermediate_certs
mkdir ca/intermediate_crl

cp -r default_ca/* ca/
unlink ca/README.MD

# Root and intermediate config
cat ca/common_header.conf ca/root_footer.conf > ca/root.conf
unlink ca/root_footer.conf
cat ca/common_header.conf ca/intermediate_footer.conf > ca/intermediate.conf
unlink ca/intermediate_footer.conf
unlink ca/common_header.conf

# Root and intermediate init
cat ca/common_init_req_header.conf ca/root_init_req_footer.conf > ca/root_init_req.conf
unlink ca/root_init_req_footer.conf
cat ca/common_init_req_header.conf ca/intermediate_init_req_footer.conf > ca/intermediate_init_req.conf
unlink ca/intermediate_init_req_footer.conf
unlink ca/common_init_req_header.conf

# Identity
cat identity/identity.conf >> ca/root_init_req.conf
cat identity/identity.conf >> ca/intermediate_init_req.conf

echo
echo 'Make changes to the .conf files in the ./ca/ folder if necessary'
echo 'Then run ./ca-setup.sh'
echo
echo 'Configured!'
