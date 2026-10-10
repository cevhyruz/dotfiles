# themes/default.bash - muted, low-contrast theme with dark and light variants
#
# Palette slots: 0 black 1 red 2 green 3 yellow 4 blue 5 magenta 6 cyan 7 white
#                8-15 the bright versions (8 is used for muted/comment text)
# Colors are RRGGBB without '#'. These are starting values: tune to taste.


THEME_DEFAULT_LOADED=0

# ---- dark (base16-solarized-dark) --------------------------------------------
# base00 002b36  base01 073642  base02 586e75  base03 657b83
# base04 839496  base05 93a1a1  base06 eee8d5  base07 fdf6e3
# base08 dc322f  base09 cb4b16  base0A b58900  base0B 859900
# base0C 2aa198  base0D 268bd2  base0E 6c71c4  base0F d33682
THEME_DARK_BG=002b36
THEME_DARK_FG=93a1a1
THEME_DARK_CURSOR=839496
THEME_DARK_PALETTE=(
    002b36 dc322f 859900 b58900 268bd2 6c71c4 2aa198 93a1a1   # 0-7
    657b83 dc322f 859900 b58900 268bd2 6c71c4 2aa198 fdf6e3   # 8-15
)
 
# ---- light (base16-solarized-light) ------------------------------------------
# base00 fdf6e3  base01 eee8d5  base02 93a1a1  base03 839496
# base04 657b83  base05 586e75  base06 073642  base07 002b36
# base08-0F: same accents as dark
THEME_LIGHT_BG=fdf6e3
THEME_LIGHT_FG=586e75
THEME_LIGHT_CURSOR=657b83
THEME_LIGHT_PALETTE=(
    fdf6e3 dc322f 859900 b58900 268bd2 6c71c4 2aa198 586e75   # 0-7
    839496 dc322f 859900 b58900 268bd2 6c71c4 2aa198 002b36   # 8-15
)
 

# TODO: add typed command color palette


# ---- roles (role -> ANSI slot) -----------------------------------------------
# Same for both variants: the palette changes, the roles don't.
THEME_ROLE=(
  [user]=2  [path]=4    [git]=5 [error]=1 [ok]=2     [warn]=3 [health]=1
  [muted]=8 [heading]=4 [arg]=6 [stash]=6 [python]=3 [node]=2
)


# man/less colors, expressed as ANSI slots so they follow the theme.
__theme::export_env_handle() {

  export LESS_TERMCAP_mb=$'\e[1m'${THEME_SGR[error]-}     # blink start
  export LESS_TERMCAP_md=$'\e[1m'${THEME_SGR[heading]-}   # bold: headings
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[7m'                         # standout: status/search
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_us=${THEME_SGR[arg]-}$'\e[4m'       # underline: arguments
  export LESS_TERMCAP_ue=$'\e[0m'
  export GROFF_NO_SGR=1                                   # make man use termcap

}

# Runs before every prompt. Must be first in PROMPT_COMMAND so $? is still the
# exit status of the command you just ran; it hands $? on unchanged.
__theme::prompt_handle() {
# TODO: Add self benchmark using EPOCHREALTIME and log it when it exceed a budget.

    local ret=$?
    THEME_ARROW=${THEME_RL[ok]}
    THEME_EXIT_SEG=

    if (( ret )); then
      THEME_ARROW=${THEME_RL[error]}
      if [[ ${THEME_EXIT:-1} == 1 ]]; then
        local mark='✗'
        (( TERM_IS_CONSOLE )) && mark='x'
        THEME_EXIT_SEG=" ${THEME_RL[error]}${mark}${ret}${THEME_RL[reset]}"
      fi
    fi

    if __common::command_exists "git"; then
      __prompt::git
      THEME_GIT_SEG=$REPLY
    fi

    __prompt::python
    THEME_PY_SEG=$REPLY

    __prompt::errlog
    THEME_ERRLOG_SEG=$REPLY

    __prompt::node
    THEME_NODE_SEG=$REPLY

    __prompt::shlvl
    THEME_SHLVL_SEG=$REPLY

    return "$ret"
}




# TODO: if possible
# [x] Add return status.
# [x] Merge the same stack (tree-like view).
# [x] Dim color for stdout.
function _ps4_callstack() {
  # set +u
  for (( i = ${#FUNCNAME[@]}; i > 0; i-- )); do
    printf '\e[33m%b\e[36m%b\e[38;5;187m%b\e[0m \e[1;31m>\e[0m ' \
      "${BASH_SOURCE[i]##*/}:" "${FUNCNAME[i]:+():}" "${BASH_LINENO[i]}"
  done
  # set -u
}

# ---- prompt -------------------------------------------------------------------
# Call after __theme::init and after sourcing lib/prompt.bash.
# PS1 is static; the git segment and arrow color come from variables that
# __theme::prompt refreshes before each prompt.
# needs 'promptvars' options to be enabled
__theme::main_handle() {
  __theme::prompt_hook

  # TODO: Basic prompt when colors are not supported. Move this in init
  if (( TERM_COLORS < 8 )); then
      PS1='\u@\h:\w${THEME_PY_SEG}${THEME_NODE_SEG}${THEME_GIT_SEG}${THEME_EXIT_SEG}${THEME_ERRLOG_SEG} \$ '
      return
  fi

  # nice symbols
  local r=${THEME_PS1[reset]} m=${THEME_PS1[muted]}
  local top='╭─' bot='╰─➤' title=

  # TODO: ASCII symbols for linux console. Move this in init
  if (( TERM_IS_CONSOLE )); then
      top='┌─' bot='└─>'
  fi

  if [[ $THEME_DEFAULT_LOADED -eq 1 ]]; then
    echo 'reset ps1'
    PS1=
  fi

  # if (( THEME_APPLIED )); then
  #   echo 'theme is applied'
  #   PS1=
  # fi

  # PS1=

  PS1+="${m}${top}${r} ${THEME_PS1[user]}\u${m}@\h${r}:${THEME_PS1[path]}\w${r}"
  PS1+='${THEME_SHLVL_SEG}${THEME_PY_SEG}${THEME_NODE_SEG}${THEME_GIT_SEG}${THEME_EXIT_SEG}${THEME_ERRLOG_SEG}'
  PS1+="\n"'${THEME_ARROW}'"${bot}${r} \\\$ "

  # PS1 does not reset the final escape sequence of the prompt string,
  # we need to normalize after reading and before executing the command.
  PS0='\n\e[0m'

  # Print newline after every command.
  ::post_command "printf '\n'"

  # PS4='$(_ps4_callstack)'


  # [?] ErrLog at the right-most with auto-adjust on resize of the terminal (1 of 2)
  # trap '__theme::errlog_winch' WINCH
}
