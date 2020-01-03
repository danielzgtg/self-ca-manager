#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo 'Expecting 1 argument: "certificate path"'
  exit 1
fi

openssl x509 -in "$1" -noout -text

exit 0
