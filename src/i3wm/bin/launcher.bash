#!/usr/bin/env bash
#
# fzf as desktop app launcher

set -e

source "${HOME}/Projects/dotfiles/src/Bash/plugins/fzf.plugin.bash"

# Name
# Exec
# Icon

# [ -n "$apps" ] && eval "$apps"


# a lancher should have:
# 1.) Core Features
# [/] launch an apps
# [ ] Show output/error of apps in notify-send
# [ ] icons
# [ ] details/actual name
# [ ] launcher logs
#
# 2.) Management Features
# [ ] Update App
# [ ] Delete App
#
# 3.) Actions Features
# [ ] support for app actions (eg, new window, new incognito, etc..)
#
# 4.) Display Feature
# [ ] display help
# [ ] display version
# [ ] Grid display
# [ ] Colored output
# [ ] location / dups in other location

# This is working in chrome
# [ -n "$apps" ] && notify-send "Launcher ${apps}" "$(gtk-launch "$apps" 2>&1)"

command cd /usr/share/applications

apps=$(command ls *.desktop 2>/dev/null | sort --unique | sed 's/\.desktop$//' | fzf --prompt=' Run app: > ');

# [?] working but don't detach to terminal

# if [ -n "$apps" ]; then
#
#     output=$(gio launch "/usr/share/applications/$apps.desktop" 2>&1)
#     if [ -n "$output" ]; then
#       notify-send "${apps}" "$output"
#     fi
#     
# fi

if [ -n "$apps" ]; then
  gio launch "/usr/share/applications/$apps.desktop" & sleep 1 &
  PID=$!;
  wait $PID;
  notify-send "Process completed"
fi


# the problem is that launching an app from gio


#==========================
# rofi dmenu.c runs app by:
# Exec
# GIO
# manual execution using execvp()

#==========================
