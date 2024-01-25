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
Mandatory environment variables:
* ```DDNS_PROVIDER``` - Dynamic DNS provider, at the moment only "duckdns" is supported.
* ```DUCKDNS_DOMAIN``` - Duck DNS domain.
* ```DUCKDNS_TOKEN``` - Duck DNS token.
* ```LETSENCRYPT_DOMAIN``` - Let's Encrypt domain. Can be the same than DUCKDNS_DOMAIN but also different in case of subdomains or wildcard certs.
* ```UID``` - UID for certbot user.
* ```GID``` - GID for certbot group.

Optional environment variables:
* ```CERTBOT_CERTONLY_ARGS``` - Command line arguments for cerbot certonly command.
* ```CERTBOT_RENEW_ARGS``` - Command line arguments for cerbot renew command.

## Mounts
Mandatory mounts:
* ```/etc/letsencrypt``` - Certbot configuration like certificates etc, to be preserved on container restarts 

Optional mounts:
* ```/var/log/letsencrypt``` - Certbot logs.

## Considerations 
* DUCKDNS_DOMAIN should be your DuckDNS domain i.e. x.duckdns.org, LETSENCRYPT_DOMAIN can be the same or then you can request certificate for subdomain i.e. y.x.duckdns.org or even wildcard domain i.e. *.x.duckdns.org (multiple domains are not supported at the moment). DUCKDNS_TOKEN can be retrieved from DuckDNS web site.
* UID and GID are needed because container runs certbot as non-root user, just in case. You can use existing user from docker host or in example some post-65536 values. Conincidentally certificates and private keys generated are owned by the same user and group so if you run other docker non-root container which consume certificates then UID and GID should be synchronized.
* CERTBOT_CERTONLY_ARGS and CERTBOT_RENEW_ARGS can be used to add command line arguments for certbot, i.e. --test-cert could be added if you just want to get (untrusted) test certificate.
* Certificates can be found from /etc/letsencrypt/certs/ as regular files (certbot creates quite bad folder structure using symlinks pointing to another folders when it comes to containers, so we just copy certificates over). 
