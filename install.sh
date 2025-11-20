#!/usr/bin/env bash

set -euo pipefail

readonly DEVENV_SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly DEVENV_MODULES_DIR="${DEVENV_SCRIPT_PATH}/modules"
readonly DEVENV_SCRIPTS_DIR="${DEVENV_SCRIPT_PATH}/scripts"
readonly DEVENV_DOTFILES_DIR="${DEVENV_SCRIPT_PATH}/dotfiles"

DRY_RUN=${DRY_RUN:-false}

log() {
  if [[ "${DRY_RUN}" == true ]]; then
    echo "[dry_run] $*"
  else
    echo "[default] $*"
  fi
}

run_cmd() {
  if [[ "${DRY_RUN}" == true ]]; then
    log "Would execute this command: '$@'"
    return 0
  fi

  "$@"
  local status=$? 
  if [[ "${status}" -ne 0 ]]; then
    log "Command failed with status ${status}: $*"
    return "${status}"
  fi
}

install_module() {
  local module="${1}"
  local module_basename=$(basename "${module}")
  if [[ -f "${module}" ]]; then
    source "${module}" && log "Sourced '${module}'"
    if ! declare -f install &>/dev/null; then
      log "Installation function is not defined for ${module_basename}"
      return
    fi
    # Dry-run is not handled here, because modules themselves 
    # handle it via run_cmd in their install() function
    install | while IFS= read -r line; do
      # Skip adding module tag for lines alread tagged with [default] or [dry_run]
      [[ "${line}" =~ ^\[(default|dry_run) ]] && echo "${line}" | sed "s/\]/|${module_basename}\]/g" && continue
      # Lines not already tagged are passed through log, which adds the default/dry_run tag
      # and then it append the module name
      log "${line}" | sed "s/\]/|${module_basename}\]/g"
    done
    # Remove it to avoid conflicts with other modules
    unset -f install
  fi
}

install_all_modules() {
  for module in "${DEVENV_MODULES_DIR}"/*; do
    install_module "${module}"
  done
}

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

cd "${DEVENV_SCRIPT_PATH}" && install_all_modules
