#!/usr/bin/env bash
# ============================================================================
# bash-autosuggestions.sh - Fish-like autosuggestions for Bash
# ============================================================================
#
# KEYBINDINGS:
#   → (Right Arrow) / End    Accept full suggestion
#   Alt+→ / Alt+F            Accept next word
#   ↑ (Up Arrow)             Next suggestion (cycle)
#   ↓ (Down Arrow)           Previous suggestion (cycle)
#   Ctrl+]                   Dismiss suggestion
#   Enter                    Execute typed text (ghost is stripped)
#
# CONFIGURATION (set before sourcing):
#   BASH_AUTOSUGGEST_HIGHLIGHT  - ANSI SGR code (default: "38;5;244")
#   BASH_AUTOSUGGEST_STRATEGY   - "history" (default) or "match_prev_cmd"
#   BASH_AUTOSUGGEST_MIN_LENGTH - min chars before suggesting (default: 1)
#   BASH_AUTOSUGGEST_HISTORY_IGNORE - glob pattern to skip
#
# REQUIREMENTS: Bash 4.0+
# ============================================================================

[[ $- != *i* ]] && return
[[ -n "$_BASH_AUTOSUGGEST_LOADED" ]] && return
_BASH_AUTOSUGGEST_LOADED=1
shopt -s extglob

: "${BASH_AUTOSUGGEST_HIGHLIGHT:=38;5;244}"
: "${BASH_AUTOSUGGEST_STRATEGY:=history}"
: "${BASH_AUTOSUGGEST_MIN_LENGTH:=1}"
: "${BASH_AUTOSUGGEST_HISTORY_IGNORE:=}"
: "${BASH_AUTOSUGGEST_MAX_CANDIDATES:=50}"

# --- Internal state ---
_bas_typed=""             # What the user actually typed
_bas_ghost=""             # The ghost suffix currently displayed
_bas_candidates=()        # All matching history entries
_bas_cand_idx=-1          # Current index in candidates (-1 = none)
_bas_showing=0            # Whether ghost text is on screen
_bas_prev_cmd=""          # Previous command (for match_prev_cmd strategy)
_bas_enabled=1            # Whether autosuggestions are enabled
_bas_pending_ghost=""     # Ghost text to display after readline redraws
_bas_pending_counter=""   # Counter text to display

# ============================================================================
# History: collect ALL matches (deduplicated, most recent first)
# ============================================================================
_bas_collect_candidates() {
    local input="$1"
    _bas_candidates=()
    _bas_cand_idx=-1

    (( ${#input} < BASH_AUTOSUGGEST_MIN_LENGTH )) && return

    local -A seen=()
    local line prev_line=""
    local contextual_matches=()
    local regular_matches=()
    
    # Read history in reverse (most recent first)
    while IFS='' read -r line; do
        # Strip leading spaces and history number
        line="${line#"${line%%[! ]*}"}"
        line="${line##+([0-9])}"
        line="${line#"${line%%[! ]*}"}"

        # Check if this line matches our input prefix
        if [[ "$line" == "$input"* && "$line" != "$input" && -z "${seen[$line]+x}" ]]; then
            if [[ -n "$BASH_AUTOSUGGEST_HISTORY_IGNORE" ]]; then
                eval "[[ \"\$line\" == $BASH_AUTOSUGGEST_HISTORY_IGNORE ]]" 2>/dev/null && continue
            fi
            seen[$line]=1
            
            # For match_prev_cmd strategy: check if prev_line matches _bas_prev_cmd
            if [[ "$BASH_AUTOSUGGEST_STRATEGY" == "match_prev_cmd" && -n "$_bas_prev_cmd" ]]; then
                if [[ "$prev_line" == "$_bas_prev_cmd" ]]; then
                    # This is a contextual match - add to priority list
                    contextual_matches+=("$line")
                else
                    regular_matches+=("$line")
                fi
            else
                # Regular history strategy
                _bas_candidates+=("$line")
                (( ${#_bas_candidates[@]} >= BASH_AUTOSUGGEST_MAX_CANDIDATES )) && break
            fi
        fi
        
        # Track previous line for context matching
        if [[ -n "$line" ]]; then
            prev_line="$line"
        fi
    done < <(HISTTIMEFORMAT='' builtin history | tac)
    
    # For match_prev_cmd: combine contextual matches first, then regular
    if [[ "$BASH_AUTOSUGGEST_STRATEGY" == "match_prev_cmd" ]]; then
        _bas_candidates=("${contextual_matches[@]}" "${regular_matches[@]}")
        # Truncate to max candidates
        if (( ${#_bas_candidates[@]} > BASH_AUTOSUGGEST_MAX_CANDIDATES )); then
            _bas_candidates=("${_bas_candidates[@]:0:$BASH_AUTOSUGGEST_MAX_CANDIDATES}")
        fi
    fi
}

# ============================================================================
# Display: colored ghost text via direct terminal output
#
# Strategy: bind -x functions execute BEFORE readline redraws. After our
# function returns, readline will redraw the prompt + READLINE_LINE and
# position the cursor at READLINE_POINT. We print our ghost text
# immediately, but it appears AFTER readline's redraw completes.
#
# The ghost text is printed with ANSI color codes directly to /dev/tty:
#   \e7        - Save cursor position (where readline left it)
#   \e[...m    - Set color (using BASH_AUTOSUGGEST_HIGHLIGHT)
#   <text>     - The ghost suggestion
#   \e[2m      - Dim attribute for counter
#   [N/M]      - Match counter if multiple suggestions
#   \e[0m      - Reset all attributes
#   \e8        - Restore cursor position
#
# On the NEXT keypress, we erase the ghost before doing anything else.
# ============================================================================
_bas_show_ghost() {
    local suffix="$1"
    [[ -z "$suffix" ]] && return

    _bas_ghost="$suffix"
    _bas_showing=1

    local count=${#_bas_candidates[@]}
    local idx_display=""
    if (( count > 1 )); then
        idx_display=" [$((_bas_cand_idx+1))/${count}]"
    fi

    # Print the ghost text and counter, then move cursor back to end of typed text
    # \e[<N>D moves cursor left N positions
    local total_ghost_len=$((${#suffix} + ${#idx_display}))
    printf '\e[%sm%s\e[0m\e[2m%s\e[0m\e[%dD' \
        "$BASH_AUTOSUGGEST_HIGHLIGHT" "$suffix" "$idx_display" "$total_ghost_len" > /dev/tty
}

_bas_clear_ghost() {
    # Always clear from cursor to end of line, regardless of state
    # This ensures ghost is removed even if _bas_showing flag is out of sync
    printf '\e[K' > /dev/tty
    _bas_ghost=""
    _bas_showing=0
    # Also clear any pending ghost that hasn't been displayed yet
    _bas_pending_ghost=""
    _bas_pending_counter=""
}


# ============================================================================
# Core: update suggestion after a keystroke
# ============================================================================
_bas_update() {
    local typed="$1"
    _bas_typed="$typed"

    READLINE_LINE="$typed"
    READLINE_POINT=${#typed}

    _bas_clear_ghost

    # Skip if disabled
    if (( ! _bas_enabled )); then
        return
    fi

    if [[ -z "$typed" ]]; then
        _bas_candidates=()
        _bas_cand_idx=-1
        return
    fi

    _bas_collect_candidates "$typed"

    if (( ${#_bas_candidates[@]} > 0 )); then
        _bas_cand_idx=0
        local suffix="${_bas_candidates[0]:${#typed}}"
        _bas_show_ghost "$suffix"
    fi
}

# Show candidate at current index
_bas_show_current_candidate() {
    _bas_clear_ghost
    if (( _bas_cand_idx >= 0 && _bas_cand_idx < ${#_bas_candidates[@]} )); then
        local suffix="${_bas_candidates[$_bas_cand_idx]:${#_bas_typed}}"
        
        # Store for async display
        _bas_pending_ghost="$suffix"
        _bas_pending_counter=""
        if (( ${#_bas_candidates[@]} > 1 )); then
            _bas_pending_counter=" [$((_bas_cand_idx+1))/${#_bas_candidates[@]}]"
        fi
        
        _bas_show_ghost_after_redisplay
    fi
}

# ============================================================================
# Key handlers
#
# IMPORTANT: bind -x replaces the normal key action.
# We must manually insert the character into READLINE_LINE.
# ============================================================================
_bas_show_ghost_after_redisplay() {
    # Display ghost text after a minimal delay using background job
    if [[ -n "$_bas_pending_ghost" ]]; then
        _bas_ghost="$_bas_pending_ghost"
        _bas_showing=1
        
        # Launch background job and immediately disown to remove from job table
        {
            # Minimal delay to let readline finish cursor positioning
            read -t 0.001 < /dev/null 2>/dev/null || true
            
            # Print ghost and reposition cursor
            printf '\e[%sm%s\e[0m\e[2m%s\e[0m\e[%dD' \
                "$BASH_AUTOSUGGEST_HIGHLIGHT" "$_bas_pending_ghost" "$_bas_pending_counter" \
                "$((${#_bas_pending_ghost} + ${#_bas_pending_counter}))" > /dev/tty
        } &>/dev/null &
        
        # Remove job from job table immediately
        disown -a 2>/dev/null
        
        _bas_pending_ghost=""
        _bas_pending_counter=""
    fi
}

_bas_self_insert_and_update() {
    local char="$1"
    _bas_clear_ghost
    
    # Insert character at cursor position
    local line="$READLINE_LINE"
    local pos="$READLINE_POINT"
    local before="${line:0:$pos}"
    local after="${line:$pos}"
    
    local new_line="${before}${char}${after}"
    local new_point=$((pos + 1))
    
    # Only show suggestions if typing at end of line and enabled
    if [[ -z "$after" ]] && (( _bas_enabled )); then
        local typed="${before}${char}"
        _bas_typed="$typed"
        
        if [[ -n "$typed" && ${#typed} -ge $BASH_AUTOSUGGEST_MIN_LENGTH ]]; then
            _bas_collect_candidates "$typed"
            
            if (( ${#_bas_candidates[@]} > 0 )); then
                _bas_cand_idx=0
                local suffix="${_bas_candidates[0]:${#typed}}"
                
                # Store the ghost to show it AFTER readline redraws
                _bas_pending_ghost="$suffix"
                _bas_pending_counter=""
                if (( ${#_bas_candidates[@]} > 1 )); then
                    _bas_pending_counter=" [$((_bas_cand_idx+1))/${#_bas_candidates[@]}]"
                fi
                
                # Update readline variables - this causes a redisplay
                READLINE_LINE="$new_line"
                READLINE_POINT=$new_point
                
                # Schedule ghost display to happen after this handler returns
                # Use PROMPT_COMMAND to display on next prompt cycle
                # Store for display after readline finishes
                trap '_bas_show_ghost_after_redisplay; trap - RETURN' RETURN
                return
            fi
        fi
    else
        # Typing in middle of line - no suggestions
        _bas_candidates=()
        _bas_cand_idx=-1
        _bas_typed="${before}${char}"
    fi
    
    # Update readline variables
    READLINE_LINE="$new_line"
    READLINE_POINT=$new_point
}

_bas_backspace_handler() {
    # Delete character before cursor
    local line="$READLINE_LINE"
    local pos="$READLINE_POINT"
    
    if (( pos > 0 )); then
        local before="${line:0:$((pos-1))}"
        local after="${line:$pos}"
        
        READLINE_LINE="${before}${after}"
        READLINE_POINT=$((pos - 1))
        
        # Clear state immediately - call _bas_clear_ghost to clear visible ghost
        _bas_clear_ghost
        
        # Only show suggestions if at end of line and enabled
        if [[ -z "$after" ]] && (( _bas_enabled )); then
            local typed="$before"
            _bas_typed="$typed"
            
            if [[ -n "$typed" && ${#typed} -ge $BASH_AUTOSUGGEST_MIN_LENGTH ]]; then
                _bas_collect_candidates "$typed"
                
                if (( ${#_bas_candidates[@]} > 0 )); then
                    _bas_cand_idx=0
                    local suffix="${_bas_candidates[0]:${#typed}}"
                    
                    # Store for async display
                    _bas_pending_ghost="$suffix"
                    _bas_pending_counter=""
                    if (( ${#_bas_candidates[@]} > 1 )); then
                        _bas_pending_counter=" [1/${#_bas_candidates[@]}]"
                    fi
                    trap '_bas_show_ghost_after_redisplay; trap - RETURN' RETURN
                else
                    _bas_candidates=()
                    _bas_cand_idx=-1
                fi
            else
                _bas_candidates=()
                _bas_cand_idx=-1
                # Clear any pending ghost and cancel any scheduled display
                _bas_pending_ghost=""
                _bas_pending_counter=""
                trap - RETURN  # Cancel any pending RETURN trap
            fi
        else
            _bas_candidates=()
            _bas_cand_idx=-1
            _bas_typed="$before"
            # Clear any pending ghost and cancel any scheduled display
            _bas_pending_ghost=""
            _bas_pending_counter=""
            trap - RETURN  # Cancel any pending RETURN trap
        fi
    else
        # At start of line - clear everything
        _bas_candidates=()
        _bas_cand_idx=-1
        _bas_pending_ghost=""
        _bas_pending_counter=""
        trap - RETURN  # Cancel any pending RETURN trap
    fi
}

_bas_delete_handler() {
    _bas_clear_ghost
    _bas_candidates=()
    _bas_cand_idx=-1
    _bas_typed="$READLINE_LINE"
}

_bas_kill_word_handler() {
    _bas_clear_ghost
    
    # Kill word backward from cursor
    local line="$READLINE_LINE"
    local pos="$READLINE_POINT"
    local before="${line:0:$pos}"
    local after="${line:$pos}"
    
    # Remove trailing spaces then word
    before="${before%"${before##*[! ]}"}"
    before="${before%"${before##* }"}"
    
    READLINE_LINE="${before}${after}"
    READLINE_POINT=${#before}
    
    # Only show suggestions if at end of line and enabled
    if [[ -z "$after" ]] && (( _bas_enabled )); then
        local typed="$before"
        _bas_typed="$typed"
        
        if [[ -n "$typed" && ${#typed} -ge $BASH_AUTOSUGGEST_MIN_LENGTH ]]; then
            _bas_collect_candidates "$typed"
            
            if (( ${#_bas_candidates[@]} > 0 )); then
                _bas_cand_idx=0
                local suffix="${_bas_candidates[0]:${#typed}}"
                
                # Store for async display
                _bas_pending_ghost="$suffix"
                _bas_pending_counter=""
                if (( ${#_bas_candidates[@]} > 1 )); then
                    _bas_pending_counter=" [1/${#_bas_candidates[@]}]"
                fi
                trap '_bas_show_ghost_after_redisplay; trap - RETURN' RETURN
            else
                _bas_candidates=()
                _bas_cand_idx=-1
            fi
        else
            _bas_candidates=()
            _bas_cand_idx=-1
        fi
    else
        _bas_candidates=()
        _bas_cand_idx=-1
        _bas_typed="$before"
    fi
}

_bas_kill_line_handler() {
    _bas_clear_ghost
    
    READLINE_LINE=""
    READLINE_POINT=0
    _bas_typed=""
    _bas_candidates=()
    _bas_cand_idx=-1
}

# ============================================================================
# Suggestion cycling (Up / Down arrows)
# ============================================================================
_bas_cycle_next() {
    if (( ${#_bas_candidates[@]} > 1 )); then
        # Multiple suggestions available - cycle through them
        _bas_cand_idx=$(( (_bas_cand_idx + 1) % ${#_bas_candidates[@]} ))
        _bas_clear_ghost
        
        # Prepare ghost for display
        local suffix="${_bas_candidates[$_bas_cand_idx]:${#_bas_typed}}"
        _bas_pending_ghost="$suffix"
        _bas_pending_counter=""
        if (( ${#_bas_candidates[@]} > 1 )); then
            _bas_pending_counter=" [$((_bas_cand_idx+1))/${#_bas_candidates[@]}]"
        fi
        
        # Display after handler returns
        trap '_bas_show_ghost_after_redisplay; trap - RETURN' RETURN
    elif (( ${#_bas_candidates[@]} == 1 )); then
        # Only one suggestion - do nothing (or could fall back to history)
        :
    else
        # No suggestions - fall back to normal history navigation
        _bas_clear_ghost
        _bas_typed="$READLINE_LINE"
        # Use readline's built-in previous-history function
        bind '"\e[A": previous-history'
        bind '"\eOA": previous-history'
        # Trigger the history command by simulating the keypress
        # (this won't work perfectly, but better than nothing)
        # User can press Up again for history navigation
    fi
}

_bas_cycle_prev() {
    if (( ${#_bas_candidates[@]} > 1 )); then
        # Multiple suggestions available - cycle through them
        _bas_cand_idx=$(( (_bas_cand_idx - 1 + ${#_bas_candidates[@]}) % ${#_bas_candidates[@]} ))
        _bas_clear_ghost
        
        # Prepare ghost for display
        local suffix="${_bas_candidates[$_bas_cand_idx]:${#_bas_typed}}"
        _bas_pending_ghost="$suffix"
        _bas_pending_counter=""
        if (( ${#_bas_candidates[@]} > 1 )); then
            _bas_pending_counter=" [$((_bas_cand_idx+1))/${#_bas_candidates[@]}]"
        fi
        
        # Display after handler returns
        trap '_bas_show_ghost_after_redisplay; trap - RETURN' RETURN
    elif (( ${#_bas_candidates[@]} == 1 )); then
        # Only one suggestion - do nothing
        :
    else
        # No suggestions - fall back to normal history navigation
        _bas_clear_ghost
        _bas_typed="$READLINE_LINE"
        bind '"\e[B": next-history'
        bind '"\eOB": next-history'
    fi
}

# ============================================================================
# Accept / dismiss
# ============================================================================
_bas_accept_full() {
    if (( _bas_showing )) && (( ${#_bas_candidates[@]} > 0 )); then
        _bas_clear_ghost
        READLINE_LINE="${_bas_candidates[$_bas_cand_idx]}"
        READLINE_POINT=${#READLINE_LINE}
        _bas_typed="$READLINE_LINE"  # Update typed to match accepted line
        _bas_showing=0
        _bas_candidates=()
        _bas_cand_idx=-1
    else
        # Default: move cursor right
        (( READLINE_POINT < ${#READLINE_LINE} )) && (( READLINE_POINT++ ))
    fi
}

_bas_accept_end() {
    if (( _bas_showing )) && (( ${#_bas_candidates[@]} > 0 )); then
        _bas_clear_ghost
        READLINE_LINE="${_bas_candidates[$_bas_cand_idx]}"
        READLINE_POINT=${#READLINE_LINE}
        _bas_typed="$READLINE_LINE"  # Update typed to match accepted line
        _bas_showing=0
        _bas_candidates=()
        _bas_cand_idx=-1
    else
        READLINE_POINT=${#READLINE_LINE}
    fi
}

_bas_accept_word() {
    if (( _bas_showing )) && (( ${#_bas_candidates[@]} > 0 )); then
        _bas_clear_ghost
        local full="${_bas_candidates[$_bas_cand_idx]}"
        local remaining="${full:${#_bas_typed}}"

        local word="" i=0 len=${#remaining}
        while (( i < len )) && [[ "${remaining:$i:1}" == " " ]]; do
            word+="${remaining:$i:1}"; (( i++ ))
        done
        while (( i < len )) && [[ "${remaining:$i:1}" != " " ]]; do
            word+="${remaining:$i:1}"; (( i++ ))
        done

        if [[ -n "$word" ]]; then
            _bas_typed+="$word"
            READLINE_LINE="$_bas_typed"
            READLINE_POINT=${#_bas_typed}
        fi

        # Re-collect candidates for the new typed prefix and show ghost
        _bas_collect_candidates "$_bas_typed"
        if (( ${#_bas_candidates[@]} > 0 )); then
            _bas_cand_idx=0
            local suffix="${_bas_candidates[0]:${#_bas_typed}}"
            if [[ -n "$suffix" ]]; then
                _bas_show_ghost "$suffix"
            else
                _bas_showing=0
            fi
        fi
    else
        local pos=$READLINE_POINT len=${#READLINE_LINE}
        while (( pos < len )) && [[ "${READLINE_LINE:$pos:1}" != " " ]]; do (( pos++ )); done
        while (( pos < len )) && [[ "${READLINE_LINE:$pos:1}" == " " ]]; do (( pos++ )); done
        READLINE_POINT=$pos
    fi
}

_bas_dismiss() {
    _bas_clear_ghost
    _bas_candidates=()
    _bas_cand_idx=-1
}

# ============================================================================
# Enter handler
#
# If ghost is showing, we just clear it — READLINE_LINE already contains
# only the typed text (ghost is purely visual via ANSI).
# Then we rebind Enter to accept-line and reinject it.
# ============================================================================
_bas_enter_handler() {
    # Only intercept if there's a ghost to clear
    # Otherwise, let Enter work normally by not rebinding
    if (( _bas_showing )); then
        _bas_clear_ghost
        _bas_candidates=()
        _bas_cand_idx=-1
    fi
    
    # Save current command for match_prev_cmd strategy
    _bas_prev_cmd="$READLINE_LINE"

    # Unbind our handler and rebind to accept-line for THIS press
    bind '"\C-m": accept-line'
    bind '"\C-j": accept-line'
    
    # Inject Enter to trigger the now-bound accept-line
    # Use ANSI sequence to inject key into input buffer
    # \x1b[200~ starts bracketed paste, then send \r, then \x1b[201~ ends it
    printf '\r' >&2
}

_bas_rebind_enter() {
    bind -x '"\C-m": _bas_enter_handler'
    bind -x '"\C-j": _bas_enter_handler'
}

# ============================================================================
# Setup
# ============================================================================
_bas_setup() {
    # Disable job control monitoring to prevent "[1] 359" messages from background jobs
    set +m
    
    # Accept / dismiss
    bind -x '"\e[C":    _bas_accept_full'
    bind -x '"\eOC":    _bas_accept_full'
    bind -x '"\e[F":    _bas_accept_end'
    bind -x '"\eOF":    _bas_accept_end'
    bind -x '"\e[4~":   _bas_accept_end'
    bind -x '"\e[1;3C": _bas_accept_word'
    bind -x '"\e\e[C":  _bas_accept_word'
    bind -x '"\ef":     _bas_accept_word'
    bind -x '"\C-]":    _bas_dismiss'

    # Suggestion cycling
    bind -x '"\e[A": _bas_cycle_next'       # Up arrow
    bind -x '"\eOA": _bas_cycle_next'       # Up arrow (alt seq)
    bind -x '"\e[B": _bas_cycle_prev'       # Down arrow
    bind -x '"\eOB": _bas_cycle_prev'       # Down arrow (alt seq)

    # Editing keys
    bind -x '"\C-?": _bas_backspace_handler'
    bind -x '"\C-h": _bas_backspace_handler'
    bind -x '"\e[3~": _bas_delete_handler'
    bind -x '"\C-w": _bas_kill_word_handler'
    bind -x '"\C-u": _bas_kill_line_handler'

    # Printable characters (ASCII 32-126)
    local code char funcname
    for code in $(seq 32 126); do
        char=$(printf "\\$(printf '%03o' "$code")")
        funcname="_bas_k${code}"
        eval "${funcname}() { _bas_self_insert_and_update $(printf '%q' "$char"); }"
        case "$code" in
            34) bind -x '"\\"": _bas_k34' ;;
            39) bind -x "\"'\": _bas_k39" ;;
            92) bind -x '"\\\\": _bas_k92' ;;
            *)  bind -x "\"${char}\": ${funcname}" ;;
        esac
    done

    # Enter - DON'T bind Enter to avoid double-press issue
    # Ghost will be cleared by PROMPT_COMMAND after command executes
    # _bas_rebind_enter

    # History
    [[ -n "$HISTFILE" ]] && history -r "$HISTFILE" 2>/dev/null

    # PROMPT_COMMAND
    _bas_prompt_hook() {
        _bas_showing=0
        _bas_ghost=""
        _bas_typed=""
        _bas_candidates=()
        _bas_cand_idx=-1
        # _bas_rebind_enter  # Not binding Enter anymore
        # Rebind arrows in case they were temporarily rebound for history nav
        bind -x '"\e[A": _bas_cycle_next'
        bind -x '"\eOA": _bas_cycle_next'
        bind -x '"\e[B": _bas_cycle_prev'
        bind -x '"\eOB": _bas_cycle_prev'
        history -a 2>/dev/null
    }

    if [[ -z "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="_bas_prompt_hook"
    elif [[ "$PROMPT_COMMAND" != *"_bas_prompt_hook"* ]]; then
        PROMPT_COMMAND="_bas_prompt_hook;$PROMPT_COMMAND"
    fi
}

# ============================================================================
# Uninstall
# ============================================================================
bash_autosuggest_disable() {
    _bas_clear_ghost
    _bas_enabled=0
    PROMPT_COMMAND="${PROMPT_COMMAND//_bas_prompt_hook;/}"
    PROMPT_COMMAND="${PROMPT_COMMAND//_bas_prompt_hook/}"

    local code char
    for code in $(seq 32 126); do
        char=$(printf "\\$(printf '%03o' "$code")")
        case "$code" in
            34) bind '"\\\"": self-insert' ;;
            39) bind "\"'\": self-insert" ;;
            92) bind '"\\\\": self-insert' ;;
            *)  bind "\"${char}\": self-insert" ;;
        esac
        unset -f "_bas_k${code}" 2>/dev/null
    done

    bind '"\C-?": backward-delete-char'
    bind '"\C-h": backward-delete-char'
    bind '"\C-w": unix-word-rubout'
    bind '"\C-u": unix-line-discard'
    bind '"\C-m": accept-line'
    bind '"\C-j": accept-line'
    bind '"\e[A": previous-history'
    bind '"\e[B": next-history'

    _BASH_AUTOSUGGEST_LOADED=""
    echo "bash-autosuggestions disabled."
}

bash_autosuggest_enable() {
    if (( _bas_enabled )); then
        echo "bash-autosuggestions already enabled."
        return
    fi
    _bas_enabled=1
    _bas_setup
    echo "bash-autosuggestions enabled."
}

bash_autosuggest_toggle() {
    if (( _bas_enabled )); then
        _bas_enabled=0
        _bas_clear_ghost
        echo "bash-autosuggestions disabled (temporary)."
    else
        _bas_enabled=1
        echo "bash-autosuggestions enabled."
    fi
}

# ============================================================================
_bas_setup
