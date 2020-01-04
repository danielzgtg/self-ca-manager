#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

echo 'Removing OpenSSL backup files...'
rm -f ca/newcerts/*.pem
find . -name '*.old' -exec unlink '{}' \;

exit 0
