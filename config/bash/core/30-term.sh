# core/term.bash - terminal capability detection
#
#
# Determine terminal capability


# core/term.bash - terminal capability detection
#
# Sets:
#   TERM_COLORS       number of colors the terminal supports (0 = none)
#   TERM_IS_CONSOLE   1 on the Linux console (TERM=linux)
#
# Must be sourced before lib/theme.bash and any theme.

TERM_COLORS=0       # number of colors the terminal supports (0 = none)
TERM_TITLE=0        # 1 if the window title escape is supported
TERM_IS_CONSOLE=0   # 1 on the Linux console (TERM=linux)
TERM_HAS_COLORS=0   # 1 if we have color support

case $TERM in
    '' | dumb) # nop
      ;;
    linux)
        TERM_IS_CONSOLE=1
        TERM_COLORS=16
        ;;
    *-256color | *-direct)                     # fast path, avoids forking tput
        TERM_COLORS=256
        ;;
    *)
        TERM_COLORS=$(tput colors 2>/dev/null) || TERM_COLORS=0
        [[ $TERM_COLORS =~ ^[0-9]+$ ]] || TERM_COLORS=0
        ;;
esac


# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set the title to 'user@host: dir'
case $TERM in
  xterm* | rxvt* | tmux* | screen* | alacritty | foot | gnome* | Eterm | aterm | kterm | kitty)
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h:  \w\a\]"
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h [$$]: \w\a\]"
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u at \h running $SHELL with PID [$$] and size [\${COLUMNS}x\${LINES}]: on \w\a\]"
    PS1='\[\e]0;${debian_chroot:+($debian_chroot)}\w [${COLUMNS}x${LINES}] \u@\h ${BASH##*/}[$$]\a\]'
  # TERM_TITLE_PS1='\[\e]0;${debian_chroot:+($debian_chroot)}\w\a\]'
    ;;
esac

if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
  TERM_HAS_COLORS=1
fi

# enable color support of ls and also add handy aliases
# if [ -x /usr/bin/dircolors ]; then
#    FIXME: this is costly, try to use other means
#    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#     alias ls='ls --color=auto'
#     #alias dir='dir --color=auto'
#     #alias vdir='vdir --color=auto'
#     alias grep='grep --color=auto'
#     alias fgrep='fgrep --color=auto'
#     alias egrep='egrep --color=auto'
# fi
