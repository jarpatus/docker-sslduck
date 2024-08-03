 # Start from Apline linux
FROM alpine:3.18

# Add packages
RUN apk add --no-cache bind-tools certbot curl py3-pip

# Copy application files to /app
COPY ./app /app

# Run init script
CMD ["sh", "/app/init.sh"]
