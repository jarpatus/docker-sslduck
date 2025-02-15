# Start from Apline linux
FROM alpine:3.18

# Build args
ARG UID=8441
ARG GID=8441

# Add packages
RUN apk add --no-cache bind-tools certbot curl py3-pip

# Add user
RUN addgroup -g $GID certbot
RUN adduser -s /sbin/nologin -G certbot -D -u $UID certbot

# Create config files
COPY ./app /app
RUN mkdir -p /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt
RUN chown -R certbot:certbot /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt

# Drop root
USER certbot

# Run init script
CMD ["sh", "/app/init.sh"]
