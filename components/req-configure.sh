#!/bin/bash
set -e
set -C
worker/usage.sh "${BASH_SOURCE[0]}" 'extension profile' -- "$@"

echo 'Will configure the certificate request for profile "'"$1"'"'
echo 'This will RESET the ./req/ folder!'

case "$1" in
  'generic')
    TYPE_PATH='generic_type.conf'
    ;;
  'minimal')
    TYPE_PATH='minimal_type.conf'
    ;;
  'custom')
    TYPE_PATH='custom_type.conf'
    ;;
  'tlsClient')
    TYPE_PATH='tls_client_type.conf'
    ;;
  'tlsServer')
    TYPE_PATH='tls_server_type.conf'
    ;;
  'httpsClient')
    TYPE_PATH='https_client_type.conf'
    ;;
  'httpsServer')
    TYPE_PATH='https_server_type.conf'
    ;;
  'bootstrap'|'init'|'ocsp')
    echo 'ERROR: Specified extension profile is to be for the CA'\''s private internal use'
    echo 'No CA would sign such a certificate for an outside entity so don'\''t even try'
    exit 1
    ;;
  *)
    echo 'ERROR: Unknown extension profile specified'
    echo 'If you only want a generic certificate, then just put "generic"'
    exit 1
    ;;
esac

worker/prompt.sh

worker/initdir.sh req
cd req

echo 'Building request config...'

echo -n "$1" > type.txt
cat req_header.conf "$TYPE_PATH" > req.conf

# Cleanup
unlink req_header.conf
rm ./*_type.conf

echo
echo 'Make changes to the .conf files in the ./req/ folder if necessary'
echo 'Then run "./self-ca-manager req setup"'
echo 'Also ask the CA for their certificate chain then place it at ./req/root.crt and ./req/chain.crt'
echo
echo 'Configured!'

exit 0
