#!/bin/sh

# Include functions
. /app/func.sh

# Add user for certbot
if ! grep -q -e "^certbot:" /etc/passwd; then
  addgroup -g $GID certbot
  adduser -s /sbin/nologin -D -u $UID -G certbot certbot
fi

# Make certbot runnable as non-root
mkdir -p /var/lib/letsencrypt
chown -R $UID:$GID /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt

# Get certificate
get_cert
if [ $? -ne 0 ]; then
  echo Could not get certificate, exiting!
  exit 1
fi

# Main loop
I=1
while true; do
  echo `date` Update IP, iteration $I...

  # Update IP
  update_ip
  if [ $? -ne 0 ]; then
    echo Could not update IP, exiting!
    exit 1
  fi

  # Renew certificate
  if [ $((I % 10)) -eq 0 ]; then
    echo Renew certificates...
    renew_cert
    if [ $? -ne 0 ]; then
      echo Could not renew certificate, exiting!
      exit 1
    fi
  fi

  # Wait for next iteration
  let "I=I+1"
  sleep 5
done
