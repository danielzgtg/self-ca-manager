#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo 'Expecting 1 argument: "dhparams path"'
  exit 1
fi

openssl dhparam -in "$1" -noout -text

exit 0
