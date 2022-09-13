#!/bin/bash

set -eux pipefail

AWS_HOSTED_ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[*].Id" --output text)

DNS_QUERY=$(aws route53 list-resource-record-sets \
    --hosted-zone-id ${AWS_HOSTED_ZONE_ID} \
    --no-paginate \
    --query "ResourceRecordSets[?(Type == 'A' || Type == 'CNAME')].Name[]" \
    --output yaml
)

echo $DNS_QUERY
