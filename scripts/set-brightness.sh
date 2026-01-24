#!/usr/bin/env bash

set -euo pipefail

# Detect the connected display output (e.g. eDP-1, HDMI-1)
output=$(xrandr | grep " connected" | cut -d " " -f1)

if [[ $# -eq 0 ]]; then

  if ! command -v fzf &>/dev/null; then
    echo "Usage: brightness <value between 0.1 and 1.0>" >&2
    echo "Without arguments, this script will show an interactive fzf menu" >&2
    exit 1
  fi

  current_brightness=$(xrandr --verbose --current | grep -m1 'Brightness' | awk '{print $NF}')
  current_brightness=$(printf "%.1f" "$current_brightness")

  brightness=$(seq 0.1 0.1 1.0 | fzf \
    --header="Current: ${current_brightness} (use j/k to navigate)" \
    --prompt="" \
    --height=15 \
    --reverse \
    --tac \
    --bind="j:down,k:up,change:clear-query" \
    --preview="echo 'Setting brightness to {}'" \
    --preview-window=up:1)

fi

brightness="${brightness:-$1}"

if ! [[ "$brightness" =~ ^0\.[1-9]$|^1\.0$|^1$ ]]; then
  echo "Error: Brightness must be a number between 0.1 and 1.0 (inclusive)" >&2
  exit 1
fi

xrandr --output "$output" --brightness "$brightness"
echo "✔ Brightness set to $brightness on output '$output'"
