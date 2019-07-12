#!/usr/bin/env bash

declare -r GITHUB_REPOSITORY="cevhyruz/dotfiles"

declare -r DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare -r DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"

declare dotfiles_directory="$HOME/Projects/dotfiles"


# Internal Function -- - - - - - - - - -  - - - - -   - -- - - - - - -

 _print_in_color() { #{{{

  printf "%b" \
    "$(tput setaf "$2" 2> /dev/null)" \
    "$1" \
    "$(tput sgr0 2> /dev/null)"
} #}}}

print_in_green() { #{{{
 _print_in_color "$1" 23
} #}}}

function installing() { #{{{

local spinner=""

while :; do
  for (( i = 0; i<${#spinner}; i++ )); do
    sleep 0.7
    echo -en "   ${spinner:$i:1} Installing precompiled binaries" "\\r"
    #     │└─ do not output trailing newlines
    #     └─ enable interpretation of backslash escapes
  done

done

} #}}}
installing

function downLoad() { #{{{

    local url="$1"
    local output="$2"

    if command -v "curl" &> /dev/null; then

        curl -LsSo "$output" "$url" &> /dev/null
        #     │││└─ write output to file
        #     ││└─ show error messages
        #     │└─ don't show the progress meter
        #     └─ follow redirects

        return $?

    elif command -v "wget" &> /dev/null; then

        wget -qO "$output" "$url" &> /dev/null
        #     │└─ write output to file
        #     └─ don't show output

        return $?
    fi

    return 1

} #}}}

function download_dotfiles() { #{{{

  local tmpfile=""

} #}}}
