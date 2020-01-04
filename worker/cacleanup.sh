#!/bin/bash
set -e

if [[ $# -ne 0 ]]; then
  echo 'Didn'\''t expect arguments'
  exit 1
fi

echo 'Removing OpenSSL backup files...'
rm -f ca/newcerts/*.pem
find . -name '*.old' -exec unlink '{}' \;

exit 0