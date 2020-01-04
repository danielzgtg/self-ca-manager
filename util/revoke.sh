#!/bin/bash
set -e

if [[ $# -ne 2 ]]; then
  echo 'Expecting 2 arguments: "config path" "input condemned certificate path"'
  exit 1
fi

openssl ca -config "$1" -revoke "$2"

exit 0
