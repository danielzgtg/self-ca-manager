#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'certificate path' -- "$@"

exec openssl verify -CAfile req/cachain.crt "$1"
