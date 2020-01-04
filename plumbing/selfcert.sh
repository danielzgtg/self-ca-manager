#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'input key path' 'output certificate path' -- "$@"

openssl req -x509 -new -days 1000 -config "$1" -key "$2" -out "$3"

exit 0
