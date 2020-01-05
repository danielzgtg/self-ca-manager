#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'input condemned certificate path' 'reason type' -- "$@"

openssl ca -config "$1" -revoke "$2" -crl_reason "$3"

exit 0
