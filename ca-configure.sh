#!/bin/bash
set -e
worker/usage.sh "${BASH_SOURCE[0]}" -- "$@"

worker/welcome.sh

echo 'Will configure the CA.'
echo 'This will RESET the ./ca/ folder!'

worker/prompt.sh

worker/initdir.sh ca
cd ca

echo 'Building CA config...'

mkdir root/crl
mkdir intermediate/certs
mkdir intermediate/crl

ca_config() {
  # $1 - CA config footer
  # $2 - signtature output type
  # $3 - output config path
  cat common/config_header.conf "$1" "$2" common/output_type_footer.conf > "$3"
  unlink "$1"
}

# Root and intermediate config
ca_config root/config_footer.conf common/intermediate_type.conf root/ca.conf
ca_config intermediate/config_footer.conf generic_type.conf intermediate/ca.conf

# Root and intermediate init
cat req_header.conf common/root_type.conf common/output_type_footer.conf > root/init_req.conf
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
