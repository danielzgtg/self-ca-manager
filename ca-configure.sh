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

add-type-directly() {
  # $1 - CA config path or self-signing request config path
  # $2 - signtature output type config path

  cat "$2" common/output_type_footer.conf >> "$1"
}

add-type() {
  # $1 - CA type
  # $2 - signtature output type config path

  add-type-directly "$1"/ca.conf "$2"
}

add-ca-info-directly() {
  # $1 - CA config path or self-signing request config path
  # $2 - CA type

  echo '
[ aia_info ]
caIssuers;URI.0 = '"$CA_DIST_URL""$2"'.crt
OCSP;URI.0 = '"$CA_DIST_URL""$2"'_ocsp/

[ crl_info ]
URI.0 = '"$CA_DIST_URL""$2"'.crl
' >> "$1"
}

add-ca-info() {
  # $1 - CA type

  add-ca-info-directly "$1"/ca.conf "$1"
}

init-ca-config() {
  # $1 - CA type

  cat common/config_header.conf "$1"/config_footer.conf > "$1"/ca.conf
  add-ca-info "$1"
  unlink "$1"/config_footer.conf
}

# Root and intermediate config
init-ca-config root
add-type root common/intermediate_type.conf
init-ca-config intermediate
add-type intermediate generic_type.conf

# Root and intermediate init
cp -T req_header.conf root/init_req.conf
add-ca-info-directly root/init_req.conf root
add-type-directly root/init_req.conf common/root_type.conf
cat req_header.conf common/intermediate_type.conf > intermediate/init_req.conf

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
