build_dir := "build"
present_tool := "slides"

# Build and present slideshow
default: present

#
setup:
  mkdir -p {{build_dir}}

# Build slideshow
build: setup
  cat ./src/order.txt | ./scripts/compile.sh > {{build_dir}}/slideshow.md

# Open windows and watch for changes
dev: setup
  # tmux new -s slideshow
  tmux split-window -v
  tmux send-keys "./scripts/watch.sh" Enter
  tmux resize-pane -D 15
  tmux select-pane -t 1
  tmux send-keys "{{slides}} {{build_dir}}/slideshow.md" Enter
  tmux split-window -h
  tmux send-keys "vi ./src" Enter
  # tmux attach -t slideshow

# Build and present slideshow
present: build
  {{present_tool}} {{build_dir}}/slideshow.md

# Show help menu
help:
  just --list

# Delete build
clean:
  rm build/ -r
