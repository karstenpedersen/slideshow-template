#!/usr/bin/env bash

while IFS= read -r line; do
  if [[ -f "$line" ]]; then
    echo "$(<"$line")"
  else
    echo "$line"
  fi
done
