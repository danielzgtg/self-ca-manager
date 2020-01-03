#!/bin/bash

. util/welcome.sh

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
[ my_req_distinguished_name ]
C = '"$C"'
ST = '"$ST"'
L = '"$L"'
O  = '"$O"'
CN = '"$O"'
emailAddress = '"$emailAddress"

echo 'Please confirm:'
echo "$RESULT"
echo

. util/prompt.sh

mkdir -p identity
echo "$RESULT" > identity/identity.conf

echo
echo 'If a CA is desired, run ./ca-configure.sh'
echo 'If a regular certificate is desired, run ./req-configure.sh'
echo
echo 'Identified!'
