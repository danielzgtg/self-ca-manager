#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"
set +e

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

worker/prompt.sh

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
http://pki.example.com/johndoecorp/
y\
y\
" | ./identify.sh
}

ca-init() {
  echo -n 'y' | ./ca-configure.sh
  echo -n 'y' | ./ca-setup.sh
}

req-init() {
  echo -n 'y' | ./req-configure.sh generic
  echo -n 'y' | ./req-setup.sh
}

req-send() {
  ./req-send.sh
}

ca-sign() {
  printf "y\ny\n" | ./ca-sign.sh generic
}

ca-respond() {
  ./ca-respond.sh
}

req-bundle() {
  ./req-bundle.sh -fast-testing-mode
}

test-ocsp() {
  echo -n 'y' | ./ca-ocsp-test-server.sh -1 intermediate 127.0.0.1:2560 > /dev/null &
  sleep 1
  ./view-ocsp.sh http://127.0.0.1:2560/ req/req.crt
}

reset
identity-setup
ca-init
req-init
req-send
ca-sign
ca-respond
req-bundle
test-ocsp

echo 'Tests passed'

exit 0
