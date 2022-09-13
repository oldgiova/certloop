#!/bin/bash

source ./tls_verificator.sh

AZURE_ZONE_IDS=$(az network dns zone list | jq '.[] | "\(.name)_\(.resourceGroup)"' | sed 's/"//g')

for AZURE_ZONE_ID in ${AZURE_ZONE_IDS}; do
  ZONE_NAME=$(echo ${AZURE_ZONE_ID} | cut -d'_' -f1)
  RG=$(echo ${AZURE_ZONE_ID} | cut -d'_' -f2)

  DNS_QUERY_CNAME=$(az network dns record-set cname list \
    -g ${RG} -z ${ZONE_NAME} \
    | jq '.[].cnameRecord.cname'
  )

  HOSTNAME_LIST=$(echo ${DNS_QUERY_CNAME} | sed 's/"//g' | sed 's/\.,//g' | sed 's/\.$//')
  
  for THIS_HOSTNAME in ${HOSTNAME_LIST}; do
    echo "DEBUG - checking cert of ${THIS_HOSTNAME}"
    openssl_expiration_checker ${THIS_HOSTNAME}
  done

  DNS_QUERY_A=$(az network dns record-set a list \
    -g ${RG} -z ${ZONE_NAME} \
    | jq '.[].fqdn'             
  )

  HOSTNAME_LIST=$(echo ${DNS_QUERY_A} | sed 's/"//g' | sed 's/\.,//g' | sed 's/\.$//')
  
  for THIS_HOSTNAME in ${HOSTNAME_LIST}; do
    echo "DEBUG - checking cert of ${THIS_HOSTNAME}"
    openssl_expiration_checker ${THIS_HOSTNAME}
  done
done
