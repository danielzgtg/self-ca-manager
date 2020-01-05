#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'input condemned certificate path' 'reason type' -- "$@"

echo 'Will revoke the specified certificate.'
echo 'The specified certificate will become UNUSABLE!'

worker/prompt.sh

echo 'Revoking specified certificate...'
plumbing/revoke.sh ca/intermediate/ca.conf "$1" "$2"

worker/gencrl.sh intermediate

worker/cacleanup.sh

echo
echo 'Specified certificate has been Revoked!'

exit 0
