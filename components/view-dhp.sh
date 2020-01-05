#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'dhparams path' -- "$@"

exec openssl dhparam -in "$1" -noout -text
