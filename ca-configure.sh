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

output_config() {
  # $1 - CA type
  # $2 - signtature output type config path
  # Output: Output type config section text

  URL_CONFIG='
[ aia_info ]
caIssuers;URI.0 = '"$CA_DIST_URL""$1"'.crt
OCSP;URI.0 = '"$CA_DIST_URL""$1"'_ocsp/

[ crl_info ]
URI.0 = '"$CA_DIST_URL""$1"'.crl
'

  cat "$2" common/output_type_footer.conf <(echo "$URL_CONFIG")
}

ca_config() {
  # $1 - CA type
  # $2 - signtature output type config path

  cat common/config_header.conf "$1"/config_footer.conf <(output_config "$1" "$2") > "$1"/ca.conf
  unlink "$1"/config_footer.conf
}

# Root and intermediate config
ca_config root common/intermediate_type.conf
ca_config intermediate generic_type.conf

# Root and intermediate init
cat req_header.conf <(output_config root common/root_type.conf) > root/init_req.conf
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
