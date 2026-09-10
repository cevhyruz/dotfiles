#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Download music and videos from youtube.

function dl_music() {
  youtube-dl --output ~/Music/"$2.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 0 "$1" --add-metadata -x
}

function dl_video() {
  youtube-dl --output ~/Videos/"$2.%(ext)s" "$1"
}
