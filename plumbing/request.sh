#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'input key path' 'output request path' -- "$@"

openssl req -new -config "$1" -key "$2" -out "$3"

exit 0
