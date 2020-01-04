#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo 'Expecting 1 argument: "CRL path"'
  exit 1
fi

openssl crl -inform DER -in "$1" -noout -text

exit 0
