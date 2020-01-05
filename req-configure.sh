#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will configure the certificate request.'
echo 'This will RESET the ./req/ folder!'

worker/prompt.sh

worker/initdir.sh req
cd req

echo 'Building request config...'

cat req_header.conf generic_type.conf > req.conf

# Cleanup
unlink req_header.conf
unlink generic_type.conf

echo
echo 'Make changes to the .conf files in the ./req/ folder if necessary'
echo 'Then run ./req-setup.sh'
echo 'Also ask the CA for their certificate chain then place it at ./req/root.crt and ./req/chain.crt'
echo
echo 'Configured!'

exit 0
