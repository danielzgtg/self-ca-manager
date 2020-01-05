#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'OCSP server URL' 'certificate path' -- "$@"

exec openssl ocsp -url "$1" -text -CAfile req/cachain.crt -issuer req/chain.crt -cert "$2"
