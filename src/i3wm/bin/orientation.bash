#!/usr/bin/env bash

get_layout() {
  i3-msg -t get_tree | jq -r '
    # find focused node
    def focused:
      .. | objects | select(.focused? == true);

    # find its parent
    def parent_of(f):
      .. | objects | select(.nodes? and (.nodes[]? == f));

    focused as $f
    | parent_of($f) as $p
    | if $f.floating == "user_on" or $f.floating == "auto_on" then
        "floating"
      elif $p.layout == "tabbed" then
        "tabbed (" + (($p.nodes | length)|tostring) + ")"
      elif $p.layout == "stacked" then
        "stacked (" + (($p.nodes | length)|tostring) + ")"
      elif $p.layout == "splith" then
        "split H (" + (($p.nodes | length)|tostring) + ")"
      elif $p.layout == "splitv" then
        "split V (" + (($p.nodes | length)|tostring) + ")"
      else
        "unknown"
      end
  '
}

# initial output
get_layout

i3-msg -t subscribe '[ "window", "workspace", "binding", "mode" ]' | while read -r _; do
  get_layout
done
