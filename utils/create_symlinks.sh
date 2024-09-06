#!/usr/bin/env bash

function create_symlink() {
  :;
}

function symlink() {
  dirs
}

function symlink_readline() {
  ln -sf "${dotfilesdir}/src/readline"
}

function symlink_vscode() {
  # link settings.json and keybindings.json in
  # ~/.config/Code/User
  true
}


function main() { :; }


create_symlink "$@"
