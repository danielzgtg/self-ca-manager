#!/bin/bash
set -e
set -C
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

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
  echo '#subjectAltName = @san' >> "$1"
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
  cat init/output_type_footer.conf >> "$1"/ca.conf
}

print-ca-info() {
  # $1 - CA type

  echo -n '
[ aia_info ]
caIssuers;URI.0 = '"$CA_DIST_URL""$1"'.crt
OCSP;URI.0 = '"$CA_DIST_URL""$1"'_ocsp/

[ crl_info ]
URI.0 = '"$CA_DIST_URL""$1"'.crl

[ ocsp_info ]
OCSP;URI.0 = '"$CA_DIST_URL""$1"'_ocsp/

[ idp_info ]
fullname = URI:'"$CA_DIST_URL""$1"'.crl
'
}

init-ca() {
  # $1 - CA type
  # $2 - CA self init signature config path

  # CA files
  cp -rt "$1"/ all/*

  # CA config
  cat init/config_header.conf "$1"/config_footer.conf > "$1"/ca.conf
  print-ca-info "$1" >> "$1"/ca.conf
  unlink "$1"/config_footer.conf
  add-type "$1" init/ocsp_type.conf

  # CA init request config
  cp -T req_header.conf "$1"/init_req.conf
  add-init-req-type "$1" "$2"
  add-init-req-type "$1" init/ocsp_type.conf
}

# Root CA

init-ca root init/root_type.conf
add-type root init/root_type.conf
add-type root init/intermediate_type.conf

# Intermediate CA

init-ca intermediate init/intermediate_type.conf
add-type intermediate generic_type.conf
add-type intermediate minimal_type.conf
add-type intermediate tls_client_type.conf
add-type intermediate tls_server_type.conf
add-type intermediate https_client_type.conf
add-type intermediate https_server_type.conf

# Custom extensions support
cp -T init/output_type_footer.conf custom_exts_header.conf
print-ca-info intermediate > custom_exts_footer.conf

# Cleanup
rm -rf init/ all/
unlink req_header.conf
rm ./*_type.conf

# Backup intermediate CA in init state; it will be copied back in ./ca-setup.sh
mv intermediate/ intermediate_init/

echo
echo 'Make changes to the .conf files in the ./ca/ folder if necessary'
echo 'Then run "./self-ca-manager ca setup"'
echo
echo 'Configured!'

exit 0
