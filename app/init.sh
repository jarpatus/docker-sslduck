#!/bin/sh

# Include functions
. /app/func.sh

# Run provider specific init script
if [ -f /app/provider/${DDNS_PROVIDER}/init ]; then
  /app/provider/${DDNS_PROVIDER}/init
fi

# Get certificate
if [ ! -z $LETSENCRYPT_DOMAIN ]; then
  echo Get certificate...
  get_cert
  if [ $? -ne 0 ]; then
    echo Could not get certificate, exiting!
    exit 1
  fi
fi

# Main loop
trap on_term TERM
I=0
while true; do
  echo `date` Update IP, iteration $I...
  let "I=I+1"

  # Update IP
  update_ip
  #if [ $? -ne 0 ]; then
  #  echo Could not update IP, exiting!
  #  exit 1
  #fi

  # Renew certificate (every 288 iterations which is 1 day when wait time is 300 seconds)
  if [ ! -z $LETSENCRYPT_DOMAIN ]; then
    if [ $((I % 288)) -eq 0 ]; then
      echo Renew certificate...
      renew_cert
      #if [ $? -ne 0 ]; then
      #  echo Could not renew certificate, exiting!
      #  exit 1
      #fi
    fi
  fi

  # Wait for next iteration
  echo Sleep until next iteration...
  sleep 300 &
  wait $!
done
