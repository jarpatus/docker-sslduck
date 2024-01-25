# docker-sslduck
Automatically update Duck DNS and renew Let's Encrypt certificate. There are dozens of docker images for doing both jobs separately but found none doing both using single container (I guess it's best practice to have one container for one job but for me personally both of these jobs are so closely coupled that I want single container).

# Build
To build image, clone repository to src/, copy example docker-compose.yaml to cwd and build:

```
git clone https://github.com/jarpatus/docker-sslduck.git src
cp src/examples/docker-compose.yaml .
docker-compose build
```

## Environment variables
* ```DDNS_PROVIDER``` - Dynamic DNS provider, at the moment only "duckdns" is supported.
* ```DUCKDNS_DOMAIN``` - Duck DNS domain.
* ```DUCKDNS_TOKEN``` - Duck DNS token.
* ```LETSENCRYPT_DOMAIN``` - Let's Encrypt domain. Can be the same than DUCKDNS_DOMAIN but also different in case of subdomains or wildcard certs.
* ```UID``` - UID for certbot user.
* ```GID``` - GID for certbot group.

## Mounts
You should use volumes or bind mounts for all following folders:
* ```/etc/letsencrypt``` - Certbot configuration like certificates etc, to be preserved on container restarts 
