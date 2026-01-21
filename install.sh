#!/usr/bin/env bash

set -euo pipefail

readonly DFILES_SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly DFILES_MODULES_DIR="${DFILES_SCRIPT_PATH}/modules"
readonly DFILES_SCRIPTS_DIR="${DFILES_SCRIPT_PATH}/scripts"
readonly DFILES_CONFIGS_DIR="${DFILES_SCRIPT_PATH}/configs"

DRY_RUN=${DRY_RUN:-false}

DFILES_LOG_LABEL=""

__dfiles_log() {
  local log_mode
  if [[ "${DRY_RUN}" == true ]]; then
    log_mode="dry_run"
  else
    log_mode="default"
  fi

  local log_prefix
  if [[ -n "${DFILES_LOG_LABEL:-}" ]]; then
    log_prefix="[$log_mode|$DFILES_LOG_LABEL]"
  else
    log_prefix="[$log_mode]"
  fi

  local log_message
  if [[ ! -t 0 ]]; then
    while IFS= read -r log_message; do
      printf '%s %s\n' "$log_prefix" "$log_message"
    done
  else
    printf '%s %s\n' "$log_prefix" "$*"
  fi
}

__dfiles_run_cmd() {
  if [[ "${DRY_RUN}" == true ]]; then
    __dfiles_log "Would execute: '$*'"
    return 0
  fi

  "$@" 2>&1 | __dfiles_log
}

install_module() {
  local module="$1"
  if [[ -f "$module" ]]; then
    DFILES_LOG_LABEL="$(basename "$module")"
    source "$module"
  fi
}

install_all_modules() {
  for module in "${DFILES_MODULES_DIR}"/*; do
    install_module "${module}"
  done
}

is_package_installed() {
  dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

install_apt_packages() {
  local packages=(
    git
    curl
    wget
    zip
    unzip
    xclip
    build-essential
    cmake
    gcc
    g++
    make
    openssl
    pkg-config
    ca-certificates
    fzf
    jq
    tree
    fd-find
    ripgrep
  )

  local to_install=()
  for package in "${packages[@]}"; do
    if is_package_installed "${package}"; then
      __dfiles_log "Package '${package}' is already installed, skipping it.."
    else
      to_install+=("${package}")
    fi
  done

  if [[ "${#to_install[@]}" -gt 0 ]]; then
    __dfiles_log "Installing ${#to_install[@]} packages: ${to_install[*]}"
    __dfiles_run_cmd sudo apt-get install -y "${to_install[@]}"
  else
    __dfiles_log "All packages are already installed"
  fi
}

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

__dfiles_run_cmd sudo apt-get update
__dfiles_run_cmd sudo apt-get upgrade -y

install_apt_packages
install_all_modules
