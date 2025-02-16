# Sslduck rootless
Automatically update IP address of your domain (aka Dynamic DNS) and renew Let's Encrypt certificate for it using DNS-01 challenge. 
There are dozens of docker images for doing both jobs separately but found none doing both using single container 
(I guess it's good practice to have one container for one job but for me personally both of these jobs are so closely coupled that I want single container). 

Following DNS providers are supported:
* Duck DNS
* OVH

# Compose file

## Example
See https://github.com/jarpatus/docker-sslduck-rootless/tree/main/examples .

## Environment
Mandatory environment variables:
* ```DDNS_PROVIDER``` - DNS provider: duckdns, ovh.
* ```DDNS_DOMAIN``` - Fully qualified domain name
* ```LETSENCRYPT_DOMAIN``` - Let's Encrypt domain. Can be the same than DDNS_DOMAIN but also different in case of subdomains or wildcard certs.

Duck DNS specific environment variables:
* ```DUCKDNS_TOKEN``` - Duck DNS token.

OVH specific environment variables:
* ```OVH_API_SERVER``` - OVH server: ovh-eu, ovh-ca, etc.
* ```OVH_APP_KEY``` - OVH application key.
* ```OVH_APP_SECRET``` - OVH application secret.
* ```OVH_CONSUMER_KEY``` - OVH consumer key.
* ```OVH_ZONE``` - OVH zone.
* ```OVH_SUBDOMAIN``` - OVH subdomain.

Optional environment variables:
* ```CERTBOT_CERTONLY_ARGS``` - Command line arguments for cerbot certonly command.
* ```CERTBOT_RENEW_ARGS``` - Command line arguments for cerbot renew command.

## Mounts
Mandatory mounts:
* ```/etc/letsencrypt``` - Certbot configuration like certificates etc, to be preserved on container restarts 

Optional mounts:
* ```/var/log/letsencrypt``` - Certbot logs.

## General instructions
* LETSENCRYPT_DOMAIN can be the same than DDNS_DOMAIN (i.e. x.example.com) or you can request certificate for subdomain i.e. y.x.example.com or even wildcard domain i.e. *.x.example.com 
* CERTBOT_CERTONLY_ARGS and CERTBOT_RENEW_ARGS can be used to add command line arguments for certbot, i.e. --test-cert could be added if you just want to get (untrusted) test certificate.
* Certificates can be found from /etc/letsencrypt/certs/ as regular files (certbot creates quite bad folder structure using symlinks pointing to another folders when it comes to containers, so we just copy certificates over). So if you did mount /etc/letsencrypt to data, you can then mount data/certs to other containers.

## Duck DNS specific instructions
* DUCKDNS_TOKEN can be retrieved from DuckDNS web site after registration.

## OVH specific instructions
* Create A record for your subdomain to desired zone from OVH control panel using short TTL. i.e: x.example.com. 60 A x.x.x.x
* Create application token for container (https://ca.api.ovh.com/createToken/) and use shown values for OVH_ environment variables. Following rights are needed:
  * GET /domain/zone/{zoneName}/record
  * POST /domain/zone/{zoneName}/record
  * DELETE /domain/zone/{zoneName}/record/*
  * PUT /domain/zone/{zoneName}/record/*
  * POST /domain/zone/{zoneName}/refresh
