#!/bin/sh

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
    ${CERTBOT_CERTONLY_ARGS}
}

renew_cert() {
  sleep $((1 + RANDOM % 10))
  certbot renew ${CERTBOT_RENEW_ARGS}
}

update_ip() {
  /app/${DDNS_PROVIDER}/update.sh
}
