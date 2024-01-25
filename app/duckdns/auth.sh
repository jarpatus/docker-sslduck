#!/bin/sh

# Update Duck DNS challenge record
CMD="curl --silent https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&txt=${CERTBOT_VALIDATION}"
RES=`${CMD}`

# Output some debugging
echo Update ${DUCKDNS_DOMAIN} with challenge: ${CERTBOT_VALIDATION}
echo Command: ${CMD}
echo Response: ${RES}

# Wait for update to be propagated
sleep 5

# Check if succeeded
test "${RES}" = "OK"
