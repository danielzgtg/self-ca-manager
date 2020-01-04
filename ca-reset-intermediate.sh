#!/bin/bash

. worker/welcome.sh

echo 'Will revoke the intermediate CA and create a new one.'
echo 'This will RESET the intermediate CA!'

. worker/prompt.sh

echo 'Revoking old intermediate CA...'
plumbing/revoke.sh ca/root/ca.conf ca/intermediate/ca.crt

echo 'Regenerating root CA CRL...'
plumbing/gencrl.sh ca/root/ca.conf ca/root/ca.crl

worker/intermediate.sh

worker/cacleanup.sh

echo
echo 'Intermediate CA has been Reset!'
