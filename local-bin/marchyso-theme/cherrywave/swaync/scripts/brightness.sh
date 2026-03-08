#!/bin/bash
case "$1" in
  get)
    ddcutil --display 1 getvcp 10 \
      | grep -oP 'current value =\s+\K\d+'
    ;;
  set)
    ddcutil --display 1 setvcp 10 "$2" > /dev/null
    ;;
esac
