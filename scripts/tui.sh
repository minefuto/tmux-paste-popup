#!/usr/bin/env bash

set -e

IFS=$'\n'
current_line=0
buffer_number=1
buffer_max_numbers=$(($(tmux list-buffer | wc -l)))
buffer_name=""
buffer=""
buffer_height=0
popup_height=0

function redraw() {
  clear
  buffer_name=$(tmux list-buffer | awk '{print substr($1, 1, length($1)-1)}' | sed -n "${buffer_number},${buffer_number}p")
  if [[ -n ${buffer_name} ]]; then
    buffer="$(tmux show-buffer -b ${buffer_name} 2>/dev/null)"
  else
    buffer=""
    buffer_number=0
  fi
  buffer_height=$(($(echo -e "${buffer}" | wc -l)))
  popup_height=$(($(tput lines)-2))
  local count=0

  while read line
  do
    if [ $((${current_line}+${popup_height})) -le ${count} ]; then
      break
    elif [ ${current_line} -le ${count} ]; then
      echo "${line}"
    fi
    count=$((${count}+1))
  done <<< "${buffer}"

  yes "_" | head -n $(tput cols) | tr -d '\n'
  echo ""
  echo -n "Paste[Yes(enter)/No(q)] Buffer[${buffer_number}/${buffer_max_numbers}] $padding"
}

function wait_key() {
  while true
  do
    redraw
    read -n1 key
    if [[ ${key} = "" ]]; then
      if [ ${buffer_max_numbers} -eq 0 ]; then
        exit 0
      fi
      tmux paste-buffer -b ${buffer_name}
      exit 0
    elif [ ${key} = "q" ]; then
      exit 0
    elif [ ${key} = "n" ]; then
      buffer_number=$((${buffer_number}-1))
      if [ ${buffer_number} -le 1 ]; then
        buffer_number=1
      fi
    elif [ ${key} = "p" ]; then
      buffer_number=$((${buffer_number}+1))
      if [ ${buffer_number} -gt ${buffer_max_numbers} ]; then
        buffer_number=${buffer_max_numbers}
      fi
    elif [ ${key} = "j" ]; then
      current_line=$((${current_line}+1))
      if [ ${current_line} -gt ${buffer_height} ]; then
        current_line=${buffer_height}
      fi
    elif [ ${key} = "k" ]; then
      current_line=$((${current_line}-1))
      if [ ${current_line} -le 0 ]; then
        current_line=0
      fi
    elif [ ${key} = "f" ]; then
      current_line=$((${current_line}+${popup_height}))
      if [ ${current_line} -gt ${buffer_height} ]; then
        current_line=${buffer_height}
      fi
    elif [ ${key} = "b" ]; then
      current_line=$((${current_line}-${popup_height}))
      if [ ${current_line} -le 0 ]; then
        current_line=0
      fi
    elif [ ${key} = "G" ]; then
      current_line=${buffer_height}
    elif [ ${key} = "g" ]; then
      current_line=0
    fi
  done
}

function main() {
  printf "\e[?25l"
  printf "\033[?7l"
  stty -echo
  trap "redraw" SIGWINCH
  trap "exit 0" SIGINT

  wait_key
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi
