#!/bin/bash
set -e

if [[ "$1" == '-y' ]]; then
  QUIET=0
  shift
else
  QUIET=1
fi

if [[ $# -ne 3 ]]; then
  echo 'Expecting 3 arguments: [-y] "config path" "input request path" "output certificate path"'
  exit 1
fi

ARGS=(-notext -config "$1" -out "$3" -infiles "$2")

if [[ $QUIET -eq 0 ]]; then
  ARGS=(-batch "${ARGS[@]}")
fi

openssl ca "${ARGS[@]}"

if [[ ! -f "$3" ]]; then
  echo 'Signing did not succeed'
  exit 1
fi

exit 0
