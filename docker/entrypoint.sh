#!/bin/bash
# docker-compose entrypoint

set -e

if [ -f /mmt/tmp/pids/server.pid ]; then
  rm /mmt/tmp/pids/server.pid
fi

docker/wait-for-postgresql.sh bundle exec rails server
