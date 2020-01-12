#!/bin/bash
set -e
set -C
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

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

REGEX='^(|http:\/\/\w+(\.\w+)*\/(\w+\/)*)$'
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
echo > identity/subject_alternative_names.conf

# CA-only
echo -n "$server" > identity/ca_dist_url.txt

echo
echo 'You might want to add same alternative names to ./identity/subject_alternative_names.conf'
echo
echo 'If a CA is desired, run "./self-ca-manager ca configure"'
echo 'If a regular certificate is desired, run "./self-ca-manager req configure (generic)"'
echo
echo 'Identified!'
