#!/bin/bash

. util/welcome.sh

if [[ $# -ne 1 ]]; then
  echo 'Expecting 1 argument: "input condemned certificate path"'
  exit 1
fi

echo 'Will revoke the specified certificate.'
echo 'The specified certificate will become UNUSABLE!'

. util/prompt.sh

echo 'Revoking specified certificate...'
util/revoke.sh ca/intermediate.conf "$1"

echo 'Generating intermediate CA CRL...'
util/gencrl.sh ca/intermediate.conf ca/intermediate.crl

util/cacleanup.sh

echo
echo 'Specified certificate has been Revoked!'
