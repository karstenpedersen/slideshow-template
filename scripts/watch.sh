#!/usr/bin/env bash

while inotifywait -r -e create,move,modify,delete ./src; do
  cat ./src/order.txt | ./compile.sh > build/slideshow.md
done;
