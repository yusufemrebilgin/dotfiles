#!/usr/bin/env bash

readonly CLIPBOARD_HISTORY="/tmp/.clipboard_history"

copy() {
  local content
  if [[ $# -eq 0 ]]; then
    content=$(cat)
  else
    content="$*"
  fi
  if [[ "${XDG_SESSION_TYPE}" == "wayland" ]]; then
    echo -n "${content}" | wl-copy
  else
    echo -n "${content}" | xclip -selection clipboard
  fi
  # Append the current content to clipboard history if it doesn't already exist
  grep -Fxq -- "${content}" "${CLIPBOARD_HISTORY}" &>/dev/null \
    || printf '%s\n' ${content} >> "${CLIPBOARD_HISTORY}"
}

paste() {
  if [[ "${XDG_SESSION_TYPE}" == "wayland" ]]; then
    wl-paste
  else
    xclip -selection clipboard -o
  fi
}

cliphist() {
  if [[ ! -f "${CLIPBOARD_HISTORY}" ]]; then
    echo "No clipboard history yet." >&2
    return 1
  fi

  local selection
  selection=$(
    tac "${CLIPBOARD_HISTORY}" | fzf \
      --height 30% \
      --reverse \
      --prompt="Clipboard>" \
      --bind="j:down,k:up,ctrl-n:down,ctrl-p:up"
  ) || return 1
  copy <<< "${selection}"
  echo "Copied selected item to clipboard."
}
