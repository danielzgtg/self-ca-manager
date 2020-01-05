#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'certificate path' -- "$@"

exec openssl x509 -in "$1" -noout -text
