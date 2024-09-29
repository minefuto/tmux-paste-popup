#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}"

current_line=0

function popup_reload() {
  clear
  local buffer=$(tmux show-buffer 2> /dev/null)
  buffer_row=$(($(echo -e "$buffer" | wc -l)-1))
  popup_row=$(($(tput lines)-2))
  last_line=$(($buffer_row-$popup_row+2))

  local count=0
  echo "$buffer" | while read line
  do
    if [ $(($current_line+$popup_row)) -le $count ]; then
      break
    elif [ $current_line -le $count ]; then
      echo "$line"
    fi
    count=$(($count+1))
  done

  yes "_" | head -n $(tput cols) | tr -d '\n'
  echo ""
  echo -n "paste? [y/n]"
}

function popup_buffer() {
  while true
  do
    read -n1 key
    if [ ${key} = "y" ]; then
      exit 0
    elif [ ${key} = "n" ]; then
      exit 1
    elif [ ${key} = "j" ]; then
      current_line=$(($current_line+1))
      if [ $current_line -gt $last_line ]; then
        current_line=$last_line
      fi
      popup_reload
    elif [ ${key} = "k" ]; then
      current_line=$(($current_line-1))
      if [ $current_line -le 0 ]; then
        current_line=0
      fi
      popup_reload
    elif [ ${key} = "f" ]; then
      current_line=$(($current_line+$popup_row))
      if [ $current_line -gt $last_line ]; then
        current_line=$last_line
      fi
      popup_reload
    elif [ ${key} = "b" ]; then
      current_line=$(($current_line-$popup_row))
      if [ $current_line -le 0 ]; then
        current_line=0
      fi
      popup_reload
    elif [ ${key} = "G" ]; then
      current_line=$last_line
      popup_reload
    elif [ ${key} = "g" ]; then
      current_line=0
      popup_reload
    fi
  done
}

printf "\e[?25l"
printf "\033[?7l"
stty -echo
trap "popup_reload" SIGWINCH

popup_reload
popup_buffer
