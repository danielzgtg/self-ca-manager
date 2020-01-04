#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'output key path' -- "$@"

openssl genrsa -out "$1" 4096

exit 0
