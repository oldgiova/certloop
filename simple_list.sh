#!/bin/bash

source ./tls_verificator.sh

while read THIS_HOSTNAME in ${HOSTNAME_LIST}; do
  echo "DEBUG - checking cert of ${THIS_HOSTNAME}"
  openssl_expiration_checker ${THIS_HOSTNAME}
done < ${1:-~/list.txt}
