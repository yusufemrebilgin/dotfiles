#!/usr/bin/env bash

set -euo pipefail

readonly UBUNTU_IMAGE_VERSION="24.04"
readonly UBUNTU_INSTANCE_NAME="test-vm"
readonly UBUNTU_INSTANCE_CPUS="2"
readonly UBUNTU_INSTANCE_DISK="10G"
readonly UBUNTU_INSTANCE_MEMORY="4G"

readonly MOUNT_SOURCE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly MOUNT_TARGET_PATH="/home/ubuntu/dev-environment"

cleanup() {
  echo "Deleting instance '${UBUNTU_INSTANCE_NAME}'"
  multipass delete "${UBUNTU_INSTANCE_NAME}" 2>/dev/null || true
  echo "Running 'multipass purge' to remove deleted instances and their data.." && multipass purge -v
  echo "Cleanup completed successfully (all related resource have been removed)"
}

if multipass list | grep -q "${UBUNTU_INSTANCE_NAME}"; then
  echo "Instance '${UBUNTU_INSTANCE_NAME}' is already exists; purging it for a clean test environment"
  cleanup
fi

echo "Creating new Ubuntu instance with version ${UBUNTU_IMAGE_VERSION}"
multipass launch "${UBUNTU_IMAGE_VERSION}" \
  --name   "${UBUNTU_INSTANCE_NAME}" \
  --cpus   "${UBUNTU_INSTANCE_CPUS}" \
  --disk   "${UBUNTU_INSTANCE_DISK}" \
  --memory "${UBUNTU_INSTANCE_MEMORY}"

echo "Mounting '${MOUNT_SOURCE_PATH}' to '${MOUNT_TARGET_PATH}'"
multipass mount "${MOUNT_SOURCE_PATH}" "${UBUNTU_INSTANCE_NAME}:${MOUNT_TARGET_PATH}"

# All script output is saved to /tmp/dev-install.log and can be inpected with 'less'
# or follow in real-time using 'tail -f'.
multipass exec "${UBUNTU_INSTANCE_NAME}" -- bash -c "cd ${MOUNT_TARGET_PATH} && stdbuf -oL -eL ./dev-install.sh | tee /tmp/dev-install.log" &>/dev/null &

# If we are already inside tmux, it will open the VM shell in a new split so we don't lose
# our current pane. Otherwise, it will just open the multipass shell normally.
if [[ -n "${TMUX:-}" ]]; then
  SIGNAL_NAME="vm-shell-signal"
  echo "Inside tmux session: splitting current window vertically and starting multipass shell"
  tmux split-window -v "multipass shell ${UBUNTU_INSTANCE_NAME}; tmux wait-for -S ${SIGNAL_NAME}"
  (
    tmux wait-for "${SIGNAL_NAME}"
    cleanup &>/dev/null
  ) &
else
  echo "Launching multipass shell normally (no tmux session detected)"
  multipass shell "${UBUNTU_INSTANCE_NAME}"
  cleanup
fi
