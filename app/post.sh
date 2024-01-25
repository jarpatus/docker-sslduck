#!/bin/sh

# Make certificates more readily available as we do not want to mount whole /etc/letsencrypt to other containers and /live has only symlinks
mkdir -m 0700 -p /etc/letsencrypt/certs
cp -rLpf /etc/letsencrypt/live/${CERTBOT_DOMAIN} /etc/letsencrypt/certs
