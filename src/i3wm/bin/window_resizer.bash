#!/bin/bash

# Get current window width
WIDTH=$(i3-msg -t get_tree | jq '.. | select(.focused? == true).rect.width')


# if [ "$1" == "up" ]; then
#     # Jump to the next step above current width
#     if   (( WIDTH >= 345 && WIDTH <= 355 )); then i3-msg "resize set 350 140, move position 510 303"
#     elif (( WIDTH < 450 )); then i3-msg "resize set 450 220, move position 458 260"
#     elif (( WIDTH < 682 )); then i3-msg "resize set 682 339, move position 341 201"
#     elif (( WIDTH < 910 )); then i3-msg "resize set 910 480, move position 227 125"
#     elif (( WIDTH < 1160 )); then i3-msg "resize set 1160 570, move position 103 84"
#     elif (( WIDTH < 1326 )); then i3-msg "resize set 1326 630, move position 21 55"
#     elif (( WIDTH < 1364 )); then i3-msg "resize set 1364 662, move position 0 35"
#     # else
#         # Already at max or larger, loop back to XXS (optional) or stay at Full
#         # i3-msg "resize set 350 140, move position 510 303"
#     fi
#
# elif [ "$1" == "down" ]; then
#     # Jump to the next step below current width
#     if   (( WIDTH > 1364 )); then i3-msg "resize set 1364 662, move position 0 35"
#     elif (( WIDTH > 1326 )); then i3-msg "resize set 1326 630, move position 21 55"
#     elif (( WIDTH > 1160 )); then i3-msg "resize set 1160 570, move position 103 84"
#     elif (( WIDTH > 910 )); then i3-msg "resize set 910 480, move position 227 125"
#     elif (( WIDTH > 682 )); then i3-msg "resize set 682 339, move position 341 201"
#     elif (( WIDTH > 450 )); then i3-msg "resize set 450 220, move position 458 260"
#     elif (( WIDTH > 350 )); then i3-msg "resize set 350 140, move position 510 303"
#     # else
#         # Already at min or smaller, loop back to Full
#         # i3-msg "resize set 1364 662, move position 0 35"
#     fi
# fi

if [ "$1" == "up" ]; then

    if   (( WIDTH >= 345  && WIDTH <= 355  )); then i3-msg "resize set 450 220, move position 458 260"
    elif (( WIDTH >= 445  && WIDTH <= 455  )); then i3-msg "resize set 682 339, move position 341 201"
    elif (( WIDTH >= 677  && WIDTH <= 687  )); then i3-msg "resize set 910 480, move position 227 125"
    elif (( WIDTH >= 905  && WIDTH <= 915  )); then i3-msg "resize set 1160 570, move position 103 84"
    elif (( WIDTH >= 1155 && WIDTH <= 1165 )); then i3-msg "resize set 1326 630, move position 21 55"
    elif (( WIDTH >= 1321 && WIDTH <= 1331 )); then i3-msg "resize set 1364 662, move position 0 35"
    else 
        # Default fallback if window size is unknown: start at XXS
        i3-msg "resize set 350 140, move position 510 303"
    fi



elif [ "$1" == "down" ]; then

    if   (( WIDTH >= 1359 && WIDTH <= 1369 )); then i3-msg "resize set 1326 630, move position 21 55"
    elif (( WIDTH >= 1321 && WIDTH <= 1331 )); then i3-msg "resize set 1160 570, move position 103 84"
    elif (( WIDTH >= 1155 && WIDTH <= 1165 )); then i3-msg "resize set 910 480, move position 227 125"
    elif (( WIDTH >= 905  && WIDTH <= 915  )); then i3-msg "resize set 682 339, move position 341 201"
    elif (( WIDTH >= 677  && WIDTH <= 687  )); then i3-msg "resize set 450 220, move position 458 260"
    elif (( WIDTH >= 445  && WIDTH <= 455  )); then i3-msg "resize set 350 140, move position 510 303"
    else
        # Default fallback: start at Full
        i3-msg "resize set 1364 662, move position 0 35"
    fi

fi

echo "Current Width: $WIDTH"
