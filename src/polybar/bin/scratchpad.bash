#!/bin/bash

# Get the number of windows in the __i3_scratch workspace
COUNT=$(i3-msg -t get_tree | jq '.. | select(.name? == "__i3_scratch") | .floating_nodes | length')

if [ "$COUNT" -gt 0 ]; then
    # Show an icon and the count (e.g.,  2)
    echo -e "  ${COUNT}"

else
    # Show nothing if empty
    echo ""
fi
