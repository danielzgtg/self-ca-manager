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
" | ./self-ca-manager identify
}

ca-init() {
  rm -rf ca
  echo 'CA Configuration'
  echo -n 'y' | ./self-ca-manager ca configure
  echo -n "$CUSTOM_EXTS" > ca/custom_exts.conf
  echo 'CA Setup'
  echo -n 'y' | ./self-ca-manager ca setup -noaes
}

req-init() {
  # $1 - extension profile
  rm -rf req
  rm -f ca/req.csr ca/req.crt
  echo 'Request Configuration'
  echo -n 'y' | ./self-ca-manager req configure "$1"
  echo -n "$CUSTOM_EXTS" > req/custom_exts.conf
  echo 'Request Setup'
  echo -n 'y' | ./self-ca-manager req setup -noaes
}

ca-sign() {
  # $1 - extension profile
  echo 'Certificate Signing'
  printf "y\ny\n" | ./self-ca-manager ca sign "$1"
}

req-bundle() {
  echo 'Result Bundling'
  ./self-ca-manager req bundle -fast-testing-mode
}

test-ocsp() {
  echo 'OCSP Client/Server'
  echo -n 'y' | ./self-ca-manager ca ocsp_test_server -1 intermediate 127.0.0.1:2560 > /dev/null &
  sleep 1
  ./self-ca-manager view ocsp http://127.0.0.1:2560/ req/req.crt
}

verify() {
  echo 'Simple Verification'
  ./self-ca-manager verify simple req/req.crt
  echo 'CRL Verification'
  ./self-ca-manager verify crl req/req.crt
}

test-cert() {
  # $1 - extension profile
  echo 'Testing a '"$1"' certificate'

  req-init "$1"
  ./self-ca-manager req send
  ca-sign "$1"
  ./self-ca-manager ca respond
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
echo '
DNS.1 = example.com
' > identity/subject_alternative_names.conf
test-cert httpsServer
echo > identity/subject_alternative_names.conf
test-cert httpsClient

echo 'Tests passed'

exit 0
