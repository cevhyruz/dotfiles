#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et


# rename an angular component
function ngrc() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: rename_component <old-component-name> <new-component-name>"
    echo "Example: rename_component profile-details account-details"
    return 1
  fi

  local old_name=$1
  local new_name=$2

  echo "converting from \"$1\" to \"$2\".."

  # Convert kebab-case to PascalCase
  to_pascal() {
    echo "$1" | sed -r 's/(^|-)(\w)/\U\2/g'
  }

  local old_class_name
  old_class_name=$(to_pascal "$old_name")
  local new_class_name
  new_class_name=$(to_pascal "$new_name")

  echo "Renaming files..."
  for ext in ts html scss spec.ts; do
    if [ -f "${old_name}.component.${ext}" ]; then
      mv "${old_name}.component.${ext}" "${new_name}.component.${ext}"
      echo "Renamed ${old_name}.component.${ext} -> ${new_name}.component.${ext}"
    fi
  done

  echo "Replacing content inside files..."
  for ext in ts html scss spec.ts; do
    local file="${new_name}.component.${ext}"
    if [ -f "$file" ]; then
      sed -i "s/${old_class_name}Component/${new_class_name}Component/g" "$file"
      sed -i "s/${old_name}.component/${new_name}.component/g" "$file"
      sed -i "s/app-${old_name}/app-${new_name}/g" "$file"
    fi
  done

  echo "Done."
}
