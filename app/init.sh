#!/bin/sh

# Include functions
. /app/func.sh

# Trap SIGTERM so we can exit gracefully on container stop
trap on_term TERM

# Add user for certbot
if ! grep -q -e "^certbot:" /etc/passwd; then
  addgroup -g $GID certbot
  adduser -s /sbin/nologin -D -u $UID -G certbot certbot
fi

# Make certbot runnable as non-root
mkdir -p /var/lib/letsencrypt
chown -R $UID:$GID /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt

# Get certificate
echo Get certificate...
get_cert
if [ $? -ne 0 ]; then
  echo Could not get certificate, exiting!
  exit 1
fi

# Main loop
I=0
while true; do
  echo `date` Update IP, iteration $I...
  let "I=I+1"

  # Update IP
  update_ip
  if [ $? -ne 0 ]; then
    echo Could not update IP, exiting!
    exit 1
  fi

  # Renew certificate (every 288 iterations which is 1 day when wait time is 300 seconds)
  if [ $((I % 288)) -eq 0 ]; then
    echo Renew certificate...
    renew_cert
    if [ $? -ne 0 ]; then
      echo Could not renew certificate, exiting!
      exit 1
    fi
  fi

  # Wait for next iteration
  echo Sleep until next iteration...
  sleep 300 &
  wait $!

done

