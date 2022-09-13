#!/bin/bash

function openssl_expiration_checker() {
  trap 'rm -f "$TMPFILE"' EXIT
  trap 'rm -f "$TMPFILE_CHECKEND"' EXIT
  TMPFILE=$(mktemp) || exit 1
  TMPFILE_CHECKEND=$(mktemp) || exit 1
  THIS_HOSTNAME=${1:-www.google.com}
  EXPIRATION_SECONDS=2592000 #30 days
  
  # test the endpoint is serving TLS in advance
  echo "Q" | openssl s_client \
    -connect ${THIS_HOSTNAME}:443 \
    -quiet \
    > $TMPFILE 2>&1

  if grep -q "errno=6" $TMPFILE; then
    echo "DNS is not resolving ${THIS_HOSTNAME}"
  elif grep -q "errno=111" $TMPFILE; then
    echo "The service ${THIS_HOSTNAME} is not exposing port 443"
  elif grep -q "errno=110" $TMPFILE; then
    echo "The service ${THIS_HOSTNAME} is not exposing port 443"
  else
    echo "Q" | openssl s_client \
      -connect ${THIS_HOSTNAME}:443 \
      2>/dev/null \
      | openssl x509 -noout -enddate -checkend ${EXPIRATION_SECONDS} > $TMPFILE_CHECKEND 2>&1
    if grep -q "Certificate will expire" $TMPFILE_CHECKEND; then
      echo "************WARNING: certificate for ${THIS_HOSTNAME} is about to expire!"
      cat $TMPFILE_CHECKEND
    fi
  fi
} 
