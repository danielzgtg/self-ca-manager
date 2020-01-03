#!/bin/bash
set -e

if [[ $# -ne 3 ]]; then
  echo 'Expecting 3 arguments: "config path" "input request path" "output certificate path"'
  exit 1
fi

openssl ca -notext -config "$1" -out "$3" -infiles "$2"

if [[ ! -f "$3" ]]; then
  echo 'Signing did not succeed'
  exit 1
fi

exit 0
