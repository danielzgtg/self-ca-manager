#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will configure the certificate request.'
echo 'This will RESET the ./req/ folder!'

worker/prompt.sh

echo 'Copying files...'

mkdir -p req
rm -rf req/*

cp -r default_req/* req/
unlink req/README.MD

cat identity/identity.conf >> req/req.conf

echo
echo 'Make changes to the .conf files in the ./req/ folder if necessary'
echo 'Then run ./req-setup.sh'
echo 'Also ask the CA for their certificate chain then place it at ./req/root.crt and ./req/chain.crt'
echo
echo 'Configured!'
