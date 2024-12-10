#!/usr/bin/env bash

set -e

function main() {
  local current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local script_path="${current_dir}/tui.sh"
  local popup_override_command="$(tmux show-options -gqv '@paste_popup_override_command')"
  local popup_width="$(tmux show-options -gqv '@paste_popup_width')"
  local popup_height="$(tmux show-options -gqv '@paste_popup_height')"

  local w_option=""
  local h_option=""

  if [[ -n ${popup_width} ]]; then
    w_option="-w${popup_width}"
  fi

  if [[ -n ${popup_height} ]]; then
    h_option="-h${popup_height}"
  fi

  if [[ -n ${popup_override_command} ]]; then
    if [ "$(${popup_override_command})" != "$(tmux show-buffer 2>/dev/null)" ]; then
      tmux set-buffer -- "$(${popup_override_command})"
    fi
  fi

  tmux popup -E ${w_option} ${h_option} ${script_path}
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi
