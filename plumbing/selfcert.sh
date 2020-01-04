#!/bin/bash
set -e

if [[ $# -ne 3 ]]; then
  echo 'Expecting 3 arguments: "config path" "input key path" "output certificate path"'
  exit 1
fi

openssl req -x509 -new -days 1000 -config "$1" -key "$2" -out "$3"

exit 0
