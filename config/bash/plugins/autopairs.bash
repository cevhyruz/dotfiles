#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC1003
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
#
# Auto-pairing for readline. Original version from
# https://github.com/nkakouros-original/bash-autopairs
#
# Features {{{1
#   Pairs        '' "" `` () [] {}
#   Quotes       Pair only at the start of a word, after an operator
#                (= | ; & < > ( { $ :), after a flag (`awk -F'`, `grep -e"`),
#                or when the previous char is a quote and the typed one is a
#                bracket (`awk '{`).
#   Skip-over    Typing a closer while the cursor is on it moves past it.
#   Word chars   No pair in the middle of a word (`don't`, `a"b`, `foo(`).
#   Before text  No pair right in front of a word char (`echo '|foo`, `(|foo`).
#   Backslash    `\'`, `\"`, `\(` are literal. `\\'` is handled correctly.
#   Other quote  Inside "..." a `'` is literal, inside '...' a `"` is, and
#                inside `...` both are.
#   Comments     Nothing pairs after an unquoted `#` that starts a word.
#   Backticks    Paired and tracked like quotes.
#   Test brackets  `[` typed inside `[|]` gives `[[ | ]]`, and `(` typed
#                inside `(|)` gives `(( | ))` (also `$((` -> `$(( | ))`).
#                Only outside quotes, so `'[[:alpha:]]'` is left alone.
#   Smart space  Space inside an empty bracket pair gives `( | )`.
#   Backspace    Removes an empty pair `(|)`, `"|"` or a spaced pair `( | )`
#                in one keypress, otherwise deletes a single char.
#   Delete       The Delete key removes `|()`, `|""` or `|( )` in one go,
#                otherwise deletes a single char.
#   Toggle       AUTOPAIRS_TOGGLE_KEY (default C-x C-p) switches pairing on
#                and off. State lives in $AUTOPAIRS_ENABLED (1 or 0), so you
#                can show it in your prompt.
#   Modes        Bound in both vi-insert and emacs keymaps.
#   Safety       Only loads in interactive shells.
#
# Limitations {{{1
#   - `$( ... )` nested inside double quotes is not tracked. In `"$(cmd "`
#     the scanner sees the inner `"` as closing the outer string, so the
#     next quote may pair oddly.
#   - Backticks are treated as flat quotes. Nested (escaped) backticks are
#     not tracked, and a backtick inside "..." is treated as literal.
#   - Here-doc bodies and `case` patterns are not recognized. Inside a
#     here-doc body, quotes follow the normal rules.
#   - Only the text before the cursor is scanned, so editing in the middle
#     of a line does not account for quotes that appear after the cursor.
#   - The line is rescanned on every quote or bracket keypress. That is
#     instant for normal lines, but very long pasted lines are slower.
#   - `bind -x` handlers cannot be undone with readline's undo as one step,
#     and they set the global `AT_PROMPT` (hack for prompt hooks).
#   - Only vi-insert and emacs keymaps are bound. vi-command is untouched.
#   - C-d is not bound, so it keeps readline's behavior (including EOF on an
#     empty line). C-w and M-Backspace do not depair.
#   - `((` is ambiguous: a nested subshell typed as `((cmd) ...)` gets the
#     arithmetic form. Backspace unwinds it, or toggle pairing off.

# Bindings only make sense with line editing
[[ $- == *i* ]] || return 0

# Config {{{1
__quote_pairs=("''" '""' '``')
__bracket_pairs=('()' '[]' '{}')
__pairs=("${__quote_pairs[@]}" "${__bracket_pairs[@]}")

# An opener autocloses only when the char before the cursor matches this
# (or the cursor is at the start of the line, or the word so far is a flag
# like `-F`). Quote characters are handled separately: they allow brackets
# (`awk '{`) but not other quotes.
AUTOPAIRS_OPEN_AFTER=$'[[:space:]=([{|;&<>$:]'

# Key sequence (readline syntax) that toggles pairing. A Ctrl sequence is used
# on purpose: binding Meta keys in vi-insert makes Esc wait for the keyseq
# timeout.
AUTOPAIRS_TOGGLE_KEY='\C-x\C-p'

# 1 = on, 0 = off. Keeps its value if you re-source this file.
: "${AUTOPAIRS_ENABLED:=1}"

BASH_AUTOPAIR_BACKSPACE=1

# Helpers {{{1

# Insert $1 at the cursor and move the cursor by $2 (default: length of $1)
__autopairs_insert() {
  READLINE_LINE="${READLINE_LINE::READLINE_POINT}${1}${READLINE_LINE:READLINE_POINT}"
  (( READLINE_POINT += ${2:-${#1}} ))
}

# Scan the line up to the cursor and report the shell quoting context.
#   __ap_state:   ''  = unquoted, "'" = in single quotes, '"' = in double
#                 quotes, '`' = in backticks, '#' = in a comment
#   __ap_escaped: 1 if the cursor directly follows an unescaped backslash
# Limitation: `$( ... )` nested inside double quotes is not tracked.
__autopairs_scan() {
  local line=${READLINE_LINE::READLINE_POINT} len c i
  local state='' prev=' ' sep='[[:space:];|&(]'
  len=${#line}
  __ap_escaped=0

  for (( i = 0; i < len; i++ )); do
    c=${line:i:1}
    case $state in
      "'")
        if [[ $c == "'" ]]; then state=''; fi
        ;;
      '#') ;;
      '`')
        if [[ $c == '\' ]]; then
          (( i++ ))
          if (( i >= len )); then __ap_escaped=1; fi
        elif [[ $c == '`' ]]; then
          state=''
        fi
        ;;
      *)
        if [[ $c == '\' ]]; then
          (( i++ ))
          if (( i >= len )); then __ap_escaped=1; fi
        elif [[ $c == '"' ]]; then
          if [[ $state == '"' ]]; then state=''; else state='"'; fi
        elif [[ -z $state ]]; then
          if [[ $c == "'" ]]; then
            state="'"
          elif [[ $c == '`' ]]; then
            state='`'
          elif [[ $c == '#' && $prev =~ $sep ]]; then
            state='#'
          fi
        fi
        ;;
    esac
    prev=$c
  done
  __ap_state=$state
}

# True if an opener may autoclose at the cursor. $1: quote | bracket
__autopairs_can_open() {
  local before=${READLINE_LINE::READLINE_POINT}
  local prev=${before: -1} cur=${READLINE_LINE:READLINE_POINT:1} word

  # Never pair right in front of a word: `echo '|foo`
  [[ $cur =~ [[:alnum:]_] ]] && return 1

  (( READLINE_POINT == 0 )) && return 0

  # After a quote char: brackets may pair (`awk '{`), quotes may not
  if [[ $prev == \' || $prev == \" || $prev == '`' ]]; then
    [[ $1 == bracket ]]
    return
  fi

  [[ $prev =~ $AUTOPAIRS_OPEN_AFTER ]] && return 0

  # Flag-attached: `awk -F'`, `grep -e"`
  word=${before##*[[:space:]]}
  [[ $word =~ ^-[[:alnum:]_-]*$ ]]
}

# Turn `[|]` into `[[ | ]]` and `(|)` into `(( | ))`. $1: open, $2: close.
# Needs __autopairs_scan to have run. Returns 1 if it did nothing.
__autopairs_expand() {
  local open=$1 close=$2
  local before=${READLINE_LINE::READLINE_POINT}
  local cur=${READLINE_LINE:READLINE_POINT:1}
  local lead allowed='[[:space:];|&]'

  [[ ${before: -1} == "$open" && $cur == "$close" ]] || return 1

  lead=${before%?}
  [[ $open == '(' ]] && allowed='[[:space:];|&$]'

  # Unquoted only, except `$((` inside double quotes
  if [[ -n $__ap_state ]]; then
    [[ $__ap_state == '"' && $open == '(' && ${lead: -1} == '$' ]] || return 1
  fi

  [[ -z $lead || ${lead: -1} =~ $allowed ]] || return 1

  __autopairs_insert "${open}  ${close}" 2
}

# Handlers {{{1

# Flip pairing on and off
autopairs_toggle() {
  AT_PROMPT=1
  if (( AUTOPAIRS_ENABLED )); then AUTOPAIRS_ENABLED=0; else AUTOPAIRS_ENABLED=1; fi
}

# autopairs TYPED OPEN CLOSE
autopairs() {
  AT_PROMPT=1 # hack for hooks triggering on 'bind -x'

  local typed=$1 open=$2 close=$3
  local cur=${READLINE_LINE:READLINE_POINT:1}

  if (( ! AUTOPAIRS_ENABLED )); then
    __autopairs_insert "$typed"
    return
  fi

  __autopairs_scan

  # Escaped, or inside a comment: always literal
  if [[ $__ap_escaped == 1 || $__ap_state == '#' ]]; then
    __autopairs_insert "$typed"
    return
  fi

  if [[ $open == "$close" ]]; then
    # Quote
    if [[ $__ap_state == "$typed" ]]; then
      # Inside this quote type: closing it
      if [[ $cur == "$typed" ]]; then
        (( READLINE_POINT++ ))
      else
        __autopairs_insert "$typed"
      fi
    elif [[ -n $__ap_state ]]; then
      # Inside another quote type: literal
      __autopairs_insert "$typed"
    elif [[ $cur != "$typed" ]] && __autopairs_can_open quote; then
      __autopairs_insert "$open$close" 1
    else
      __autopairs_insert "$typed"
    fi
  elif [[ $typed == "$open" ]]; then
    # Opening bracket
    if [[ $open == '[' || $open == '(' ]] && __autopairs_expand "$open" "$close"; then
      :
    elif __autopairs_can_open bracket; then
      __autopairs_insert "$open$close" 1
    else
      __autopairs_insert "$typed"
    fi
  else
    # Closing bracket
    if [[ $cur == "$close" ]]; then
      (( READLINE_POINT++ ))
    else
      __autopairs_insert "$typed"
    fi
  fi
}

# Space between an empty bracket pair gives `( | )`
autopairs_smart_space() {
  AT_PROMPT=1

  local prev='' cur=${READLINE_LINE:READLINE_POINT:1} pair
  (( READLINE_POINT > 0 )) && prev=${READLINE_LINE:READLINE_POINT-1:1}

  if (( AUTOPAIRS_ENABLED )); then
    for pair in "${__bracket_pairs[@]}"; do
      if [[ $prev == "${pair:0:1}" && $cur == "${pair:1:1}" ]]; then
        __autopairs_insert "  " 1
        return
      fi
    done
  fi
  __autopairs_insert " "
}

# Backspace: remove an empty pair (`(|)`, `( | )`) or a single char
__depair() {
  AT_PROMPT=1

  (( READLINE_POINT == 0 )) && return 0

  local before=${READLINE_LINE::READLINE_POINT}
  local after=${READLINE_LINE:READLINE_POINT}
  local pair

  if (( AUTOPAIRS_ENABLED )); then
    # Adjacent pair: `(|)` `"|"`
    for pair in "${__pairs[@]}"; do
      if [[ ${before: -1} == "${pair:0:1}" && ${after::1} == "${pair:1:1}" ]]; then
        READLINE_LINE="${before%?}${after:1}"
        (( READLINE_POINT-- ))
        return
      fi
    done

    # Spaced pair: `( | )`, drop one space on each side
    for pair in "${__bracket_pairs[@]}"; do
      if [[ ${before: -2} == "${pair:0:1} " && ${after::2} == " ${pair:1:1}" ]]; then
        READLINE_LINE="${before%?}${after:1}"
        (( READLINE_POINT-- ))
        return
      fi
    done
  fi

  # Plain backspace
  READLINE_LINE="${before%?}${after}"
  (( READLINE_POINT-- ))
}

# Delete key: remove an empty pair under the cursor (`|()`, `|( )`) or a
# single char
__autopairs_delete() {
  AT_PROMPT=1

  (( READLINE_POINT >= ${#READLINE_LINE} )) && return 0

  local before=${READLINE_LINE::READLINE_POINT}
  local after=${READLINE_LINE:READLINE_POINT}
  local pair

  if (( AUTOPAIRS_ENABLED )); then
    # Opener with its closer right behind: `|()` `|""`
    for pair in "${__pairs[@]}"; do
      if [[ ${after::2} == "$pair" ]]; then
        READLINE_LINE="${before}${after:2}"
        return
      fi
    done

    # Spaced pair: `|( )`
    for pair in "${__bracket_pairs[@]}"; do
      if [[ ${after::3} == "${pair:0:1} ${pair:1:1}" ]]; then
        READLINE_LINE="${before}${after:3}"
        return
      fi
    done
  fi

  # Plain delete
  READLINE_LINE="${before}${after:1}"
}

# Bindings {{{1

# Disabled: showing the matching paren hijacks `)`, `]` and `}`
bind 'set blink-matching-paren off'

for __map in vi-insert emacs; do
  for __pair in "${__pairs[@]}"; do
    __open=${__pair:0:1} __close=${__pair:1:1}
    printf -v __qo '%q' "$__open"
    printf -v __qc '%q' "$__close"

    __key=$__open
    [[ $__open == '"' ]] && __key='\"'
    bind -m "$__map" -x "\"$__key\": autopairs $__qo $__qo $__qc"

    if [[ $__open != "$__close" ]]; then
      bind -m "$__map" -x "\"$__close\": autopairs $__qc $__qo $__qc"
    fi
  done

  bind -m "$__map" -x '" ": autopairs_smart_space'
  bind -m "$__map" -x '"\C-h": __depair'
  bind -m "$__map" -x '"\e[3~": __autopairs_delete'
  bind -m "$__map" -x "\"$AUTOPAIRS_TOGGLE_KEY\": autopairs_toggle"

  if [[ -v BASH_AUTOPAIR_BACKSPACE ]]; then
    # https://lists.gnu.org/archive/html/bug-bash/2019-11/msg00129.html
    bind 'set bind-tty-special-chars off'
    bind -m "$__map" -x '"\C-?": __depair'
  fi
done
unset __map __pair __open __close __qo __qc __key
