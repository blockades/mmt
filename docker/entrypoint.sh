#!/bin/bash
# docker-compose entrypoint

set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
docker/wait-for-postgresql.sh postgres bundle exec rails server
