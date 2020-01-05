#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'CRL path' -- "$@"

exec openssl crl -inform DER -in "$1" -noout -text
