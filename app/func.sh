#!/bin/sh

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

update_ip() {
  export IP=`curl --silent https://api.ipify.org`
  /app/provider/${DDNS_PROVIDER}/update
}
