#!/bin/sh

on_term() {
  echo Killed, exiting...
  exit 1
}

get_cert() {
  certbot certonly \
    --manual \
    --non-interactive \
    --test-cert \
    --agree-tos \
    --register-unsafely-without-email \
    --preferred-challenges dns \
    --manual-auth-hook /app/${DDNS_PROVIDER}/auth.sh \
    --manual-cleanup-hook /app/${DDNS_PROVIDER}/cleanup.sh \
    --post-hook /app/post.sh \
    --domains $LETSENCRYPT_DOMAIN \
    ${CERTBOT_CERTONLY_ARGS} &
  wait $!
}

renew_cert() {
  sleep $((1 + RANDOM % 10)) &
  wait $!
  certbot renew ${CERTBOT_RENEW_ARGS} &
  wait $!
}

update_ip() {
  /app/${DDNS_PROVIDER}/update.sh &
  wait $!
}
