#!/bin/sh

get_cert() {
  sudo -E -u certbot certbot certonly \
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
  sudo -E -u certbot certbot renew \
    ${CERTBOT_RENEW_ARGS}
}

update_ip() {
  sudo -E -u certbot /app/${DDNS_PROVIDER}/update.sh
}
