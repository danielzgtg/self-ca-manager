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

CUSTOM_EXTS='
subjectKeyIdentifier = hash
basicConstraints = critical, CA:FALSE
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment, keyAgreement
extendedKeyUsage = codeSigning
certificatePolicies = 2.5.29.32.0
'

identity-setup() {
  echo 'Identity Setup'
  rm -rf identity
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
  rm -rf ca
  echo 'CA Configuration'
  echo -n 'y' | ./ca-configure.sh
  echo -n "$CUSTOM_EXTS" > ca/custom_exts.conf
  echo 'CA Setup'
  echo -n 'y' | ./ca-setup.sh
}

req-init() {
  # $1 - extension profile
  rm -rf req
  rm -f ca/req.csr ca/req.crt
  echo 'Request Configuration'
  echo -n 'y' | ./req-configure.sh "$1"
  echo -n "$CUSTOM_EXTS" > req/custom_exts.conf
  echo 'Request Setup'
  echo -n 'y' | ./req-setup.sh
}

ca-sign() {
  # $1 - extension profile
  echo 'Certificate Signing'
  printf "y\ny\n" | ./ca-sign.sh "$1"
}

req-bundle() {
  echo 'Result Bundling'
  ./req-bundle.sh -fast-testing-mode
}

test-ocsp() {
  echo 'OCSP Client/Server'
  echo -n 'y' | ./ca-ocsp-test-server.sh -1 intermediate 127.0.0.1:2560 > /dev/null &
  sleep 1
  ./view-ocsp.sh http://127.0.0.1:2560/ req/req.crt
}

verify() {
  echo 'Simple Verification'
  ./verify-simple.sh req/req.crt
  echo 'CRL Verification'
  ./verify-crl.sh req/req.crt
}

test-cert() {
  # $1 - extension profile
  echo 'Testing a '"$1"' certificate'

  req-init "$1"
  ./req-send.sh
  ca-sign "$1"
  ./ca-respond.sh
  req-bundle
  test-ocsp
  verify
}

rm -rf ca
rm -rf identity
rm -rf req

identity-setup
ca-init
test-cert generic
test-cert custom
echo '
DNS.1 = *.example.org
DNS.2 = *.example.net
DNS.3 = example.org
DNS.4 = example.net
' > identity/subject_alternative_names.conf
test-cert generic
test-cert custom
echo '
IP.1 = 192.168.2.100
' > identity/subject_alternative_names.conf
test-cert vpnServer
echo > identity/subject_alternative_names.conf
test-cert vpnClient

echo 'Tests passed'

exit 0
