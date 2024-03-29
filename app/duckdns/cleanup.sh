#!/bin/sh

# Clear Duck DNS challenge record
CMD="curl --silent https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&txt=${CERTBOT_VALIDATION}&clear=true"
RES=`${CMD}`

# Output some debugging
echo Clear ${DUCKDNS_DOMAIN} challenge: ${CERTBOT_VALIDATION}
echo Command: ${CMD}
echo Response: ${RES}

# Check if succeeded
test "${RES}" = "OK"
