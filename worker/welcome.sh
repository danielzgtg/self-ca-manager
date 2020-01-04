#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

echo 'Welcome to self-ca-manager!'

exit 0
