#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}"

function main() {
  paste_enhanced_override_command="$(tmux show-options -gqv '@paste_enhanced_override_command')"

  if [ -n paste_enhanced_override_command ]; then
    tmux set-buffer -- $($paste_enhanced_override_command)
  fi
  tmux popup -E "$SCRIPTS_DIR/popup.sh"
  if [ $? -eq 0 ]; then
    tmux paste-buffer
  fi
}

main
