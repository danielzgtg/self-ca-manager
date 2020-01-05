#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will configure the CA.'
echo 'This will RESET the ./ca/ folder!'

worker/prompt.sh

CA_DIST_URL=$(cat identity/ca_dist_url.txt)

worker/initdir.sh ca
cd ca

echo 'Building CA config...'

mkdir root/crl
mkdir intermediate/certs
mkdir intermediate/crl

add-req-type-directly() {
  # $1 - CA config path or self-signing request config path
  # $2 - signtature output type config path

  cat "$2" >> "$1"
}

add-init-req-type() {
  # $1 - CA type
  # $2 - signtature output type config path

  add-req-type-directly "$1"/init_req.conf "$2"
}

add-type() {
  # $1 - CA type
  # $2 - signtature output type config path

  add-req-type-directly "$1"/ca.conf "$2"
  cat common/output_type_footer.conf >> "$1"/ca.conf
}

init-ca() {
  # $1 - CA type
  # $2 - CA self init signature config path

  # CA config
  cat common/config_header.conf "$1"/config_footer.conf > "$1"/ca.conf
  echo '
[ aia_info ]
caIssuers;URI.0 = '"$CA_DIST_URL""$1"'.crt
OCSP;URI.0 = '"$CA_DIST_URL""$1"'_ocsp/

[ crl_info ]
URI.0 = '"$CA_DIST_URL""$1"'.crl
' >> "$1"/ca.conf
  unlink "$1"/config_footer.conf
  add-type "$1" common/ocsp_type.conf

  # CA init request config
  cp -T req_header.conf "$1"/init_req.conf
  add-init-req-type "$1" "$2"
  add-init-req-type "$1" common/ocsp_type.conf
}

# Root CA

init-ca root common/root_type.conf
add-type root common/root_type.conf
add-type root common/intermediate_type.conf

# Intermediate CA

init-ca intermediate common/intermediate_type.conf
add-type intermediate generic_type.conf

# Cleanup
rm -rf common/
unlink req_header.conf
unlink generic_type.conf

# Backup intermediate CA in init state; it will be copied back in ./ca-setup.sh
mv intermediate/ intermediate_init/

echo
echo 'Make changes to the .conf files in the ./ folder if necessary'
echo 'Then run ./ca-setup.sh'
echo
echo 'Configured!'

exit 0
