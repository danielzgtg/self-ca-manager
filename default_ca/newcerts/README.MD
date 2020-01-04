The ./ca/newcerts/ folder is kept empty.
The scripts manage a copy of  all certificates in ./ca/certs/ instead.
This folder is needed because OpenSSL insists on creating certificates here with a header.
