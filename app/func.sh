#!/bin/sh

on_term() {
  echo Got sigterm...
  exit 0
}

get_cert() {
  certbot certonly \
    --manual \
    --non-interactive \
    --agree-tos \
    --register-unsafely-without-email \
    --preferred-challenges dns \
    --manual-auth-hook /app/provider/${DDNS_PROVIDER}/auth \
    --manual-cleanup-hook /app/provider/${DDNS_PROVIDER}/cleanup \
    --post-hook /app/post.sh \
    --domains $LETSENCRYPT_DOMAIN \
    ${CERTBOT_CERTONLY_ARGS}
}

renew_cert() {
  sleep $((1 + RANDOM % 10))
  certbot renew ${CERTBOT_RENEW_ARGS}
}

get_dns_ip() {
  export DNS_IP=`dig +short ${DDNS_DOMAIN}`
  echo DNS IP: ${DNS_IP}
}

get_ext_ip() {
  export EXT_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
  echo External IP: ${EXT_IP}
}

update_ip() {
  get_dns_ip
  get_ext_ip
  if [ "${DNS_IP}" != "${EXT_IP}" ]; then
    /app/provider/${DDNS_PROVIDER}/update
  else
    echo No update required.
  fi
}
