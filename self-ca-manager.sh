#!/bin/bash
set -e

echo 'Welcome to self-ca-manager!'

usage() {
  echo -n '
Usage: '"${BASH_SOURCE[0]}"' <ca|identify|req|verify|view>
    ca <configure|ocsp_test_server|reset_intermediate|respond|revoke|setup|sign> [args ...]
    identify
    req <bundle|configure|send|setup> [args ...]
    verify <crl|simple> <certificate path>
    view <crl|crt|dhp|ocsp|req> <input path>
'
  exit 1
}

if [[ $# -eq 0 ]]; then
  usage
fi

declare -i len i
for command in components/*; do
  script=${command#components/}
  read -ra path_parts <<< "${script//./ }"
  script_name=${path_parts[0]}
  read -ra command_parts <<< "${script_name//-/ }"
  len=${#command_parts[@]}
  if [[ $# -ge $len ]]; then
    for ((i=1; i <= len; i++)); do
      if [[ "${!i}" != "${command_parts[$((i - 1))]}" ]]; then
        continue 2
      fi
    done
    # shellcheck disable=SC2086
    shift $len
    found="$command"
    break
  fi
done

if [[ -n "$found" ]]; then
  exec "$found" "$@"
else
  echo
  echo 'ERROR: Command not found'
  usage
fi
