#!/bin/bash

source ./tls_verificator.sh

AWS_HOSTED_ZONE_IDS=$(aws route53 list-hosted-zones --query "HostedZones[*].Id" --output text)

for AWS_HOSTED_ZONE_ID in ${AWS_HOSTED_ZONE_IDS}; do
  echo ${AWS_HOSTED_ZONE_ID}
  DNS_QUERY=$(aws route53 list-resource-record-sets \
    --hosted-zone-id ${AWS_HOSTED_ZONE_ID} \
    --no-paginate \
    --query "ResourceRecordSets[?(Type == 'A' || Type == 'CNAME')].Name[]" \
    | grep -v '\[\|\]' \
  )

  HOSTNAME_LIST=$(echo ${DNS_QUERY} | sed 's/"//g' | sed 's/\.,//g' | sed 's/\.$//')
  
  for THIS_HOSTNAME in ${HOSTNAME_LIST}; do
    echo "DEBUG - checking cert of ${THIS_HOSTNAME}"
    openssl_expiration_checker ${THIS_HOSTNAME}
  done
done
