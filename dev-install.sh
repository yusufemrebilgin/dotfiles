#!/usr/bin/env bash

set -euo pipefail

readonly DEVENV_SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly DEVENV_SCRIPT_MODULES_DIR="${DEVENV_SCRIPT_PATH}/modules"
readonly DEVENV_SCRIPT_MODULE_FUNC_NAME="run_module_installation"

DRY_RUN=false

log() {
  if [[ "${DRY_RUN}" == true ]]; then
    echo "[dry_run] ${@}"
  else
    echo "[default] ${@}"
  fi
}

install_module() {
  local module="${1}"
  local module_script=$(basename "${module}")
  source "${module}"
  if ! declare -f ${DEVENV_SCRIPT_MODULE_FUNC_NAME} &>/dev/null; then
    echo "${DEVENV_SCRIPT_MODULE_FUNC_NAME} is not defined for ${module_script}" >&2
    return
  fi

  if [[ "${DRY_RUN}" == true ]]; then
    log "Would run '${module_script}' installation script"
    return
  fi

  "${DEVENV_SCRIPT_MODULE_FUNC_NAME}" | while IFS= read -r line; do
    log "[${module_script}] ${line}" | sed 's/\] \[/|/g'
  done

  unset "${DEVENV_SCRIPT_MODULE_FUNC_NAME}"
}

install_all_modules() {
  for module in "${DEVENV_SCRIPT_MODULES_DIR}"/*; do
    install_module "${module}"
  done
}

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

cd "${DEVENV_SCRIPT_PATH}" && install_all_modules
