#!/bin/bash

. worker/welcome.sh

echo 'Will configure the CA.'
echo 'This will RESET the ./ca/ folder!'

. worker/prompt.sh

echo 'Copying files...'

mkdir -p ca
rm -rf ca/*

cp -r default_ca/* ca/

mkdir ca/root/crl
mkdir ca/intermediate/certs
mkdir ca/intermediate/crl

# Root and intermediate config
cat ca/common/config_header.conf ca/root/config_footer.conf > ca/root/ca.conf
unlink ca/root/config_footer.conf
cat ca/common/config_header.conf ca/intermediate/config_footer.conf > ca/intermediate/ca.conf
unlink ca/intermediate/config_footer.conf

# Root and intermediate init
cat ca/common/init_req_header.conf ca/root/init_req_footer.conf > ca/root/init_req.conf
unlink ca/root/init_req_footer.conf
cat ca/common/init_req_header.conf ca/intermediate/init_req_footer.conf > ca/intermediate/init_req.conf
unlink ca/intermediate/init_req_footer.conf

# Cleanup
unlink ca/README.MD
rm -rf ca/common/

# Identity
cat identity/identity.conf >> ca/root/init_req.conf
cat identity/identity.conf >> ca/intermediate/init_req.conf

# Backup intermediate CA in init state; it will be copied back in ./ca-setup.sh
mv ca/intermediate/ ca/intermediate_init/

echo
echo 'Make changes to the .conf files in the ./ca/ folder if necessary'
echo 'Then run ./ca-setup.sh'
echo
echo 'Configured!'
