#!/bin/bash
set -euxo pipefail

ssh-keygen -t ed25519 -f test-data/id -N ''
mkdir -p test-data/remote/.ssh
cat test-data/id.pub >> test-data/config/.ssh/authorized_keys
echo
cat -n test-data/config/.ssh/authorized_keys
