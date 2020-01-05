#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'directory purpose' -- "$@"

if [[ ! "$1" =~ [a-z]+ ]]; then
  echo 'Internal Error: Directory purpose must be lowercase ASCII'
  exit 1
fi

do-init() {
  mkdir -p ./"$1"/ # Ensure directory exists but don't destroy symlinks
  rm -rf ./"$1"/* # Reset first
  cp -rt ./"$1"/ default/"$1"/*  # Actually copy
  unlink ./"$1"/README.MD # README.MD refers to template itself
}

echo 'Setting up ./'"$1"'/ directory...'

# Identity is a special case
if [[ "$1" == 'identity' ]]; then
  do-init identity
  exit 0
fi

# Validate the directory purpose
case "$1" in
  'all')
    echo 'Internal Error: The "all" directory purpose can'\''t be directly initialized'
    exit 1
    ;;
  'ca')
    # Valid
    ;;
  'req')
    # Valid
    ;;
  *)
    echo 'Internal Error: Unknown directory purpose: '"$1"
    exit 1
    ;;
esac

GLOBAL_ID_PATH=identity/req_header.conf
if [[ ! -f "$GLOBAL_ID_PATH" ]]; then
  echo 'ERROR: ID is missing'
  echo 'Please run ./identify.sh first'
  exit 1
fi

# Purpose-specific files
do-init "$1"

# Common files
cp -rt ./"$1"/ default/all/*
unlink ./"$1"/README.MD # README.MD refers to template itself
cp -T "$GLOBAL_ID_PATH" ./"$1"/req_header.conf

exit 0
