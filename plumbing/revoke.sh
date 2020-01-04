#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'input condemned certificate path' -- "$@"

openssl ca -config "$1" -revoke "$2"

exit 0
