#!/bin/bash
# docker-compose entrypoint

set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

docker/wait-for-postgresql.sh bundle exec rails server
