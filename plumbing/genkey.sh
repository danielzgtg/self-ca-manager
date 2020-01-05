#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" '-noaes' 'output key path' -- "$@"

if [[ "$1" == '-noaes' ]]; then
  AES=1
  shift
else
  AES=0
fi

declare -a ARGS=(-out "$1" 4096)
if [[ $AES -eq 0 ]]; then
  ARGS=(-aes256 "${ARGS[@]}")
fi
openssl genrsa "${ARGS[@]}"

exit 0
