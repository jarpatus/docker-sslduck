#!/bin/sh

# Update Duck DNS IP
CMD="curl --silent ${DUCKDNS_IP_ARGS} https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&ip="
RES=`${CMD}`

# Output some debugging
echo Update ${DUCKDNS_DOMAIN} IP...
echo Command: ${CMD}
echo Response: ${RES}

# Check if succeeded
test "${RES}" = "OK"
