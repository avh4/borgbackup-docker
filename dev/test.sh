#!/bin/bash
set -euxo pipefail

SSH_USER=linuxserver.io
SSH_PORT=38592
REPO_NAME="r1"

# Generate SSH key if needed
# TODO: should also check if test-data/id.pub is in test-data/config/.ssh/authorized_keys
if [ ! -e test-data/id ]; then
  test-data/genkey.sh
fi

REPO_URL="ssh://${SSH_USER}@localhost:${SSH_PORT}/data/${REPO_NAME}"
SSH_ARGS=(-i "$(pwd)/test-data/id" -o "AddKeysToAgent No" -o "UserKnownHostsFile $(pwd)/test-data/known_hosts")
BORG_RSH="ssh $(printf "%q " "${SSH_ARGS[@]}")"
export BORG_RSH

# Initialize borg repository if needed
if [ ! -e test-data/remote/"$REPO_NAME" ]; then
  borg init "$REPO_URL" -e none
fi

# Make a backup
ARCHIVE_NAME="$(date)"
(cd test-data/local; borg create "${REPO_URL}::${ARCHIVE_NAME}" ./)

# Print repository info
borg list "$REPO_URL"
borg info "$REPO_URL"

