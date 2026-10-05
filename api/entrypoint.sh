#!/bin/sh
# The API creates a fresh database from schema.sql on first start.
# No user database ships with this repo.
set -e
if [ "$(id -u)" = "0" ]; then
  mkdir -p /data/mail-outbox
  chown -R labz:labz /data
  exec su -s /bin/sh labz -c 'exec python3 /app/server.py'
fi
exec python3 /app/server.py
