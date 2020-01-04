#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'CRL path' -- "$@"

openssl crl -inform DER -in "$1" -noout -text

exit 0
