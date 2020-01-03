#!/bin/bash

. util/welcome.sh

echo 'Will configure the CA.'
echo 'This will RESET the ./ca/ folder!'

. util/prompt.sh

echo 'Copying files...'

mkdir -p ca
rm -rf ca/*
cp -r default_ca/* ca/
unlink ca/README.MD

echo 'Configured!'
