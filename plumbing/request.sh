#!/bin/bash
set -e

if [[ $# -ne 3 ]]; then
  echo 'Expecting 3 arguments: "config path" "input key path" "output request path"'
  exit 1
fi

openssl req -new -config "$1" -key "$2" -out "$3"

exit 0
