#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo 'Expecting 1 argument: "output key path"'
  exit 1
fi

openssl genrsa -out "$1" 4096

exit 0
