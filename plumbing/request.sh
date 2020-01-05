#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'input key path' 'output request path' 'extension profile' -- "$@"

openssl req -new -config "$1" -key "$2" -out "$3" -reqexts "$4"_ext

exit 0
