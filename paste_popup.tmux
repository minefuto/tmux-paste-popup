#!/usr/bin/env bash

set -e

function main() {
  local current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local script_path="${current_dir}/scripts/paste_popup.sh"
  local paste_key="$(tmux show-options -gqv '@paste_popup_key')"

  if [[ -n ${paste_key} ]]; then
    tmux unbind ${paste_key}
    tmux bind-key ${paste_key} run-shell "${script_path}"
  else
    tmux unbind ]
    tmux bind-key ] run-shell "${script_path}"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi
