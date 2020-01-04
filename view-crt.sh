#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'certificate path' -- "$@"

openssl x509 -in "$1" -noout -text

exit 0
