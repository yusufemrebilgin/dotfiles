#!/usr/bin/env bash

set -euo pipefail

readonly DFILES_SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly DFILES_MODULES_DIR="${DFILES_SCRIPT_PATH}/modules"
readonly DFILES_SCRIPTS_DIR="${DFILES_SCRIPT_PATH}/scripts"
readonly DFILES_CONFIGS_DIR="${DFILES_SCRIPT_PATH}/configs"

DRY_RUN=${DRY_RUN:-false}
INTERACTIVE=${INTERACTIVE:-false}

# Appends a context label to log output, identifying which module or operation
# is currently executing. Automatically set and cleared by install_module() 
# when sourcing modules.
#
# Format:
#   [<mode>|<label>] <message>        - With label
#   [<mode>] <message>                - Without label
#
DFILES_LOG_LABEL=""

read -r -d '' EDITOR_MSG_TEMPLATE <<EOF || true
# Edit this file to control which modules are installed.
# Save and exit to apply your changes.
#
# One module per line. Comments and empty lines are ignored.
#
# Available modules:

{module-dir-list}
EOF

__dfiles_log() {
  local log_mode="default"
  if [[ "${DRY_RUN}" == true ]]; then
    log_mode="dry_run"
  fi
  local log_prefix="[$log_mode]"
  if [[ -n "${DFILES_LOG_LABEL:-}" ]]; then
    log_prefix="[${log_mode}|${DFILES_LOG_LABEL}]"
  fi

  if [[ ! -t 0 ]]; then
    local log_message
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

__dfiles_link() {
  local src="$1"
  local dest="$2"
  if [[ ! -e "$src" ]]; then
    __dfiles_log "Failed to create link '$src': Source does not exists"
    return 1
  fi
  if [[ -L "$dest"  || -e "$dest" ]]; then
    __dfiles_log "Removing existing link target '$dest'"
    __dfiles_run_cmd rm -rf "$dest"
  fi

  local parent_dir="$(dirname "$dest")"
  if [[ ! -d "$parent_dir" ]]; then
    __dfiles_run_cmd mkdir -pv "$parent_dir"
  fi
  
  __dfiles_run_cmd ln -sv "$src" "$dest"
}

select_modules_with_editor() {
  local tmpfile="$(mktemp)"
  local editor="${EDITOR:-vi}"

  echo "$EDITOR_MSG_TEMPLATE" > "$tmpfile"
  sed -i "/{module-dir-list}/r"<(ls -1 "$DFILES_MODULES_DIR") "$tmpfile"
  sed -i "/{module-dir-list}/d" "$tmpfile"

  "$editor" "$tmpfile"

  SELECTED_MODULES=()
  while IFS= read -r line; do
    SELECTED_MODULES+=("$line")
  done < <(grep -v '^#' "$tmpfile" | grep -v '^[[:space:]]*$')

  rm "$tmpfile"
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
    if ! is_package_installed "$package"; then
      to_install+=("$package")
    fi
  done

  if [[ "${#to_install[@]}" -gt 0 ]]; then
    __dfiles_log "Installing ${#to_install[@]} packages: ${to_install[*]}"
    __dfiles_run_cmd sudo apt-get install -y "${to_install[@]}"
  else
    __dfiles_log "All packages are already installed"
  fi
}

install_module() {
  local module="$1"
  if [[ -f "$module" ]]; then
    DFILES_LOG_LABEL="$(basename "$module")"
    source "$module"
    DFILES_LOG_LABEL=""
  fi
}

install_all_modules() {
  for module in "${DFILES_MODULES_DIR}"/*; do
    install_module "${module}"
  done
}

install_selected_modules() {
  for module_name in "${SELECTED_MODULES[@]}"; do
    local module_path="${DFILES_MODULES_DIR}/${module_name}"
    if [[ -f "$module_path" ]]; then
      install_module "$module_path"
    else
      __dfiles_log "Warning: Module '$module_name' not found, skipping"
    fi
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --interactive|-i)
      INTERACTIVE=true
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 [--dry-run] [--interactive|-i]" >&2
      exit 1
      ;;
  esac
done

if [[ "${INTERACTIVE}" == true ]]; then
  select_modules_with_editor
  if [[ "${#SELECTED_MODULES[@]}" -eq 0 ]]; then
    __dfiles_log "No modules selected, exiting"
    exit 0
  fi
  __dfiles_log "Selected ${#SELECTED_MODULES[@]} module(s): ${SELECTED_MODULES[*]}"
fi

__dfiles_run_cmd sudo apt-get update
__dfiles_run_cmd sudo apt-get upgrade -y

install_apt_packages

if [[ "${INTERACTIVE}" == true ]]; then
  install_selected_modules
else
  install_all_modules
fi
