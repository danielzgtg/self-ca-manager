#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" 'extension profile' -- "$@"

worker/welcome.sh

echo 'Will configure the certificate request for profile "'"$1"'"'
echo 'This will RESET the ./req/ folder!'

worker/prompt.sh

worker/initdir.sh req
cd req

echo 'Building request config...'

echo -n "$1" > type.txt

case "$1" in
  'generic')
    TYPE_PATH='generic_type.conf'
    ;;

  'custom')
    if [[ ! -f req/custom_exts.conf ]]; then
      echo 'You need to specify custom extensions in ./req/custom_exts.conf'
      exit 1
    fi
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

cat req_header.conf "$TYPE_PATH" > req.conf

# Cleanup
unlink req_header.conf
unlink generic_type.conf

echo
echo 'Make changes to the .conf files in the ./req/ folder if necessary'
echo 'Then run ./req-setup.sh'
echo 'Also ask the CA for their certificate chain then place it at ./req/root.crt and ./req/chain.crt'
echo
echo 'Configured!'

exit 0
