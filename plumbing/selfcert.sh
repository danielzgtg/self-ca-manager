#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'input request path' 'output certificate path' -- "$@"

openssl ca -selfsign -batch -notext -config "$1" -extensions bootstrap_ext -out "$3" -infiles "$2"

exit 0
