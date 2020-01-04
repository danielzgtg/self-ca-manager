#!/bin/bash

if [[ ! -f testmode ]]; then
  echo 'You are not running tests'
  echo 'DO NOT run this ./testcase.sh script!!!'
  echo 'It will delete your data every time!!!'
  exit 1
fi

err() {
  echo 'A test failed on line '"$1"
  exit 1
}

set -o errtrace
trap 'err $LINENO $' ERR

echo 'Automated test cases'
echo 'This will DELETE all existing data!!!'

. util/prompt.sh

reset() {
  rm -rf ca
  rm -rf identity
  rm -rf req
}

identity-setup() {
  echo 'Identity Setup'
  echo -n "\
CA\
Ontario
Toronto
John Doe
test@example.com
y" | ./identify.sh
}

ca-init() {
  echo -n 'y' | ./ca-configure.sh
  echo -n 'y' | ./ca-setup.sh
}

req-init() {
  echo -n 'y' | ./req-configure.sh
  echo -n 'y' | ./req-setup.sh
}

req-send() {
  ./req-send.sh
}

ca-sign() {
  printf "y\ny\n" | ./ca-sign.sh
}

ca-respond() {
  ./ca-respond.sh
}

req-bundle() {
  ./req-bundle.sh
}

reset
identity-setup
ca-init
req-init
req-send
ca-sign
ca-respond
req-bundle

echo 'Tests passed'
