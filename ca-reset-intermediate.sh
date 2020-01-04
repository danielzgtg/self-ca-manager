#!/bin/bash

. util/welcome.sh

echo 'Will revoke the intermediate CA and create a new one.'
echo 'This will RESET the intermediate CA!'

. util/prompt.sh

echo 'Revoking old intermediate CA...'
util/revoke.sh ca/root.conf ca/intermediate.crt

echo 'Generating root CA CRL...'
util/gencrl.sh ca/root.conf ca/root.crl

util/intermediate.sh

util/cacleanup.sh

echo
echo 'Intermediate CA has been Reset!'
