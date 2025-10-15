#!/bin/sh
set -e

if [ -n "$DB_HOST" ] && [ -n "$DB_PORT" ]; then
  echo "Waiting for DB $DB_HOST:$DB_PORT ..."
  until nc -z $DB_HOST $DB_PORT; do
    sleep 1
  done
  echo "DB is up!"
fi

if [ "$RUN_MIGRATIONS" = "true" ]; then
  echo "Running migrations (programmatic)..."
  node dist/scripts/migrate.js || true
fi

echo "Starting app..."
exec "$@"
