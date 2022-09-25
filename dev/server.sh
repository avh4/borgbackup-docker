#!/bin/bash
set -euxo pipefail

# Rebuild
docker-compose build dev

# Generate server keys if needed
if [ ! -e test-data/config/ssh_host_keys ]; then
  docker-compose run --rm --entrypoint /keygen.sh dev
fi

# Start server
docker-compose up dev

