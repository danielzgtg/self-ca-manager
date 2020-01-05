#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" '-noaes' -- "$@"

if [[ "$1" == '-noaes' ]]; then
  AES=1
  shift
else
  AES=0
fi

if [[ -d ca/intermediate ]]; then
  echo 'Rotating out old intermediate CA...'
  mv -f ca/intermediate/ ca/intermediate_old/
fi

echo 'Inflating intermediate CA...'
cp -r ca/intermediate_init/ ca/intermediate/

declare -a ARGS=(intermediate root)
if [[ $AES -ne 0 ]]; then
  ARGS=(-noaes "${ARGS[@]}")
fi
worker/initca.sh "${ARGS[@]}"

worker/gencrl.sh root
worker/gencrl.sh intermediate

exit 0
