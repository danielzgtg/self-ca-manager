#!/bin/bash

. worker/welcome.sh

echo 'Will revoke the intermediate CA and create a new one.'
echo 'This will RESET the intermediate CA!'

. worker/prompt.sh

echo 'Revoking old intermediate CA...'
plumbing/revoke.sh ca/root.conf ca/intermediate.crt

echo 'Generating root CA CRL...'
plumbing/gencrl.sh ca/root.conf ca/root.crl

worker/intermediate.sh

worker/cacleanup.sh

echo
echo 'Intermediate CA has been Reset!'
