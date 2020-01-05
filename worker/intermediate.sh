#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

if [[ -d ca/intermediate ]]; then
  echo 'Rotating out old intermediate CA...'
  mv -f ca/intermediate/ ca/intermediate_old/
fi

echo 'Inflating intermediate CA...'
cp -r ca/intermediate_init/ ca/intermediate/

worker/initca.sh intermediate root

worker/gencrl.sh root
worker/gencrl.sh intermediate

exit 0
