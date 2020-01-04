#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'dhparams path' -- "$@"

openssl dhparam -in "$1" -noout -text

exit 0
