#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'certificate path' -- "$@"

exec openssl verify -crl_check -CAfile req/cachain.crl "$1"
