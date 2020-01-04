#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

if [[ $# -ne 1 ]]; then
  echo 'Expecting 1 argument: "input condemned certificate path"'
  exit 1
fi

echo 'Will revoke the specified certificate.'
echo 'The specified certificate will become UNUSABLE!'

worker/prompt.sh

echo 'Revoking specified certificate...'
plumbing/revoke.sh ca/intermediate/ca.conf "$1"

worker/intermediatecrl.sh

worker/cacleanup.sh

echo
echo 'Specified certificate has been Revoked!'
