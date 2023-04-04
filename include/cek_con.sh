#!/bin/bash

cek_con() {
  if ping -q -c 1 -W 1 google.com >/dev/null; then
    echo "Connected to internet"
  else
    echo "No internet connection"
    exit 1
  fi
}