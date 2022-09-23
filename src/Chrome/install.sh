#!/usr/bin/env bash
#
# google chrome extension installer.
# reference:
#   https://developer.chrome.com/docs/extensions/mv3/external_extensions/#preferences
# usage:
#   install_chrome_extension [ID] [NAME]

declare -a extension=(
  "react dev tools" "dbepggeogbaibhgnhhndojpepiihcmeb"
  "vimium"          "dbepggeogbaibhgnhhndojpepiihcmeb"
  "screen saver"    "dbepggeogbaibhgnhhndojpepiihcmeb"
  "consoler"        "dbepggeogbaibhgnhhndojpepiihcmeb"
)

install_chrome_extension () {
  if ! which "xgoogle-chrome" &> /dev/null; then
    echo "No Chrome executable found, would you like to install it?"
    read -r -n1 REPLY
    return 1
  else
    echo 'hoho'
    return 1
  fi

  echo 'test'

  preferences_dir_path="/opt/google/chrome/extensions"

  mkdir -p "${preferences_dir_path}"
  echo "{" > "${pref_file_path}"
  echo "  \"external_update_url\": \"${upd_url}\"" >> "$pref_file_path"
  echo "}" >> "$pref_file_path"
  echo Added \""$pref_file_path"\" ["$2"]
}

install_chrome_extension "$@"
