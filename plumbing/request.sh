#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'config path' 'input key path' 'output request path' 'extension profile' -- "$@"

ARGS=(-new -config "$1" -key "$2" -out "$3")

if [[ "$4" == 'custom' ]]; then
  ARGS=(-extfile ca/custom_exts.conf "${ARGS[@]}")
else
  ARGS=(-reqexts "$4"_ext "${ARGS[@]}")
fi

openssl req "${ARGS[@]}"

exit 0
