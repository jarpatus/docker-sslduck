#!/bin/sh

# Add user for certbot
if ! grep -q -e "^certbot:" /etc/passwd; then
  addgroup -g $GID certbot
  adduser -s /sbin/nologin -D -u $UID -G certbot certbot
fi

# Make certbot runnable as non-root
mkdir -p /var/lib/letsencrypt
chown -R $UID:$GID /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt

# Run provider specific init script
if [ -f /app/provider/${DDNS_PROVIDER}/init ]; then
  /app/provider/${DDNS_PROVIDER}/init
fi

# Trap SIGTERM so we can exit gracefully on container stop
on_term() {
  echo Killed, exiting...
}
trap on_term TERM

# Run main script as certbot user
su certbot -s /bin/sh -c /app/main.sh &
wait $!
