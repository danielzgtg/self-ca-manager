#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" \
  '-y' 'config path' 'input request path' 'output certificate path' 'extension profile' -- "$@"

if [[ "$1" == '-y' ]]; then
  QUIET=0
  shift
else
  QUIET=1
fi

ARGS=(-notext -config "$1" -out "$3" -infiles "$2")

if [[ $QUIET -eq 0 ]]; then
  ARGS=(-batch "${ARGS[@]}")
fi

if [[ "$4" == 'custom' ]]; then
  ARGS=(-extfile ca/custom_exts_actual.conf "${ARGS[@]}")
  cat ca/custom_exts_header.conf ca/custom_exts.conf ca/custom_exts_footer.conf > ca/custom_exts_actual.conf
else
  ARGS=(-extensions "$4"_ext "${ARGS[@]}")
fi

openssl ca "${ARGS[@]}"

if [[ ! -f "$3" ]]; then
  echo 'Signing did not succeed'
  exit 1
fi

exit 0
