#!/usr/bin/env bash
#
# Build config files from templates.

# search and replace, then save a file copy to a location.
function build_configfiles() {
  local index src dest

  # source templates are the odd entry following their
  # corresponding destination path.
  declare -a template_src_and_dest=(
   "${dotfilesdir}/src/Bash/.bashrc.template"
   "${HOME}/.bashrc"
   "${dotfilesdir}/src/Git/.gitconfig.template"
   "${HOME}/.gitconfig"
   "${dotfilesdir}/src/readline/inputrc.template"
   "${HOME}/.inputrc"
  )

  declare -A replacements=(
    ["DOTFILES"]="${dotfilesdir}"
    ["TIMESTAMP"]="# Timestamp: $(date "+%a - %h %d, %Y (%I:%M %p)")"
    ["WARNING"]="# This is auto-generated file, do not modify!"
  )

  for (( i = 0; i < $(( "${#template_src_and_dest[@]}" / 2 )); i++ )); do
    index=$(( i * 2 ))
    src="$(<${template_src_and_dest[$index]})"
    dest="${template_src_and_dest[$index + 1]}"
    for keyword in "${!replacements[@]}"; do
      src="$(sed "s|{{ ${keyword} }}|${replacements[$keyword]}|" <<< "$src")"
    done
    echo "$src" > "$dest"
    printf "\n"
  done
}

function build_templates() {
  local index src dest

  # source templates are the odd entry following their
  # corresponding destination path.
  declare -a template_src_and_dest=(
   "${dotfilesdir}/src/Bash/.bashrc.template"
   "${HOME}/.bashrc"
   "${dotfilesdir}/src/Git/.gitconfig.template"
   "${HOME}/.gitconfig"
   "${dotfilesdir}/src/readline/inputrc.template"
   "${HOME}/.inputrc"
  )

  declare -A replacements=(
    ["DOTFILES"]="${dotfilesdir}"
    ["TIMESTAMP"]="# Timestamp: $(date "+%a - %h %d, %Y (%I:%M %p)")"
    ["WARNING"]="# This is auto-generated file, do not modify!"
  )

  for (( i = 0; i < $(( "${#template_src_and_dest[@]}" / 2 )); i++ )); do
    index=$(( i * 2 ))
    src="$(<${template_src_and_dest[$index]})"
    dest="${template_src_and_dest[$index + 1]}"
    for keyword in "${!replacements[@]}"; do
      src="$(sed "s|{{ ${keyword} }}|${replacements[$keyword]}|" <<< "$src")"
    done
    echo "$src" > "$dest"
    printf "\n"
  done
}

function main() {
  print::jobname "Config files"

  execute "build_templates" "Building config files from templates"
}

main "$@"
