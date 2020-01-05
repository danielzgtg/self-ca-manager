#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will set up the CA.'
echo 'This will REPLACE the CA key!'

worker/prompt.sh

worker/initca.sh root root

worker/intermediate.sh

worker/cacleanup.sh

echo
echo 'Now wait for certificate requests and place the request at ./ca/req.csr'
echo 'Then run ./ca-sign.sh'
echo
echo 'Setup done!'

exit 0
