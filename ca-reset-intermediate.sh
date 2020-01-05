#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will revoke the intermediate CA and create a new one.'
echo 'This will RESET the intermediate CA!'

worker/prompt.sh

echo 'Revoking old intermediate CA...'
plumbing/revoke.sh ca/root/ca.conf ca/intermediate/ca.crt

worker/rootcrl.sh

worker/intermediate.sh

worker/cacleanup.sh

echo
echo 'Intermediate CA has been Reset!'

exit 0
