#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'request path' -- "$@"

exec openssl req -in "$1" -noout -text
