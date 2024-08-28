#!/bin/bash

echo "### Stop nginx ####"
docker compose stop nginx
echo

echo "#### Renew certificate ####"
docker compose run --rm -p 80:80 -p 443:443 --entrypoint  "certbot renew --standalone" certbot

echo "### Stert nginx #####"
docker compose start nginx
