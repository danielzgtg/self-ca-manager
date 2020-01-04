#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'request path' -- "$@"

if [[ $# -ne 1 ]]; then
  echo 'Expecting 1 argument: "request path"'
  exit 1
fi

openssl req -in "$1" -noout -text

exit 0
