#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will set your identity.'
echo 'Please enter your info below'
echo

read -p 'Country Code (2 letters): ' -r -n 2 C
echo
read -p 'State or Province: ' -r ST
read -p 'Locality (City): ' -r L
read -p 'Name: ' -r O
read -p 'Email Address: ' -r emailAddress
echo

RESULT='
C = '"$C"'
ST = '"$ST"'
L = '"$L"'
O  = '"$O"'
CN = '"$O"'
emailAddress = '"$emailAddress"

echo 'Please confirm:'
echo "$RESULT"
echo

worker/prompt.sh

worker/initdir.sh identity

cat identity/req_header_header.conf <(echo "$RESULT") > identity/req_header.conf
unlink identity/req_header_header.conf

echo
echo 'If a CA is desired, run ./ca-configure.sh'
echo 'If a regular certificate is desired, run ./req-configure.sh'
echo
echo 'Identified!'
