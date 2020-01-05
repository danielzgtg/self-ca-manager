#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will set your identity.'
echo 'Please enter your personal information below:'
echo

read -rp 'Country Code (2 letters): ' -n 2 C
echo
read -rp 'State or Province: ' ST
read -rp 'Locality (City): ' L
read -rp 'Name: ' O
read -rp 'Email Address: ' emailAddress
echo

echo 'Please enter your server information below:'
echo 'Leave blank if you are not a CA'
echo

read -rp 'Certificate Distribution Server (HTTP URL to subdirectory): ' server
echo

REGEX='^http:\/\/\w+(\.\w+)*\/(\w+\/)*$'
if [[ ! "$server" =~ $REGEX ]]; then
  echo 'Expected an URL that looks like http://pki.example.com/johndoecorp/'
  exit 1
fi

RESULT="\
C = $C
ST = $ST
L = $L
O  = $O
CN = $O
emailAddress = $emailAddress
"

echo 'Please confirm the personal information for "'"$O"'":'
echo
echo "$RESULT"
worker/prompt.sh
echo

echo 'Please confirm the information for the CA:'
echo
echo 'Distribution URL: '"$server"
echo
worker/prompt.sh
echo

worker/initdir.sh identity

# Global
cat identity/req_header_header.conf <(echo -n "$RESULT") > identity/req_header.conf
unlink identity/req_header_header.conf

# CA-only
echo -n "$server" > identity/ca_dist_url.txt

echo
echo 'If a CA is desired, run ./ca-configure.sh'
echo 'If a regular certificate is desired, run ./req-configure.sh (generic)'
echo
echo 'Identified!'
