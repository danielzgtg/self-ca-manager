#!/bin/bash
set -e

internal-fail() {
  echo 'Internal Syntax: <script name> [argument type description] ... -- [actual argument] ...'
  exit 1
}

external-fail() {
  USAGE='Usage: '"$PARENT"

  for OPTIONAL in "${OPTIONALS[@]}"; do
    USAGE+=' ['"$OPTIONAL"']'
  done

  for TYPE in "${TYPES[@]}"; do
    USAGE+=' <'"$TYPE"'>'
  done

  echo "$USAGE"
  exit 1
}

# Parse to internal
if [[ -z "$1" ]]; then
  internal-fail
fi
PARENT="$1"
shift

declare -a OPTIONALS=()
while [[ "$1" == '-'*  ]]; do
  if [[ "$1" == '--' ]]; then
    break
  fi
  OPTIONALS+=("$1")
  shift
done

declare -a TYPES=()
while [[ "$1" != '--' ]]; do
  if [[ -z "$1" ]]; then
    internal-fail
  fi
  TYPES+=("$1")
  shift
done

if [[ "$1" != '--' ]]; then
  internal-fail
fi
shift

# Check external syntax

declare -i IDX=0
while [[ "$1" == '-'* ]]; do
  OPTIONAL="${OPTIONALS[IDX]}"
  if [[ "$1" == "$OPTIONAL" ]]; then
    shift
  elif [[ -z "$OPTIONAL" ]]; then
    echo 'Unknown option: '"$1"
    external-fail
  fi
  ((++IDX))
done

declare -i LEN=${#TYPES[@]}
if [[ $# -ne $LEN ]]; then
  case $LEN in
    0)
      echo 'Didn'\''t expect any arguments, got '"$#"
      ;;
    1)
      echo 'Expected 1 argument, got '"$#"
      ;;
    *)
      echo 'Expected '"$LEN"' arguments, got '"$#"
      ;;
  esac
  external-fail
fi

# Got here, so OK
exit 0
