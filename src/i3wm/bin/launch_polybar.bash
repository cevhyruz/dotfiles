#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
#
polybar-msg cmd quit
#
# Otherwise you can use the nuclear option:
#
# killall -q polybar

# Launch bar
echo "---" | tee -a /tmp/main.log /tmp/main.log
polybar example 2>&1 | tee -a /tmp/main.log & disown

# TODO: dynamically get the active bars to launch.

echo "Bars launched..."
