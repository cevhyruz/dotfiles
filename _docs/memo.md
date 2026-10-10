# Notes for me

## xdg directory specificiation


### Default $HOME directory

```
Desktop/      - $XDG_DESKTOP_DIR 
Documents/    - $XDG_DOCUMENTS_DIR
Downloads/    - $XDG_DOWNLOAD_DIR
Music/        - $XDG_MUSIC_DIR
Pictures/     - $XDG_PICTURES_DIR
Public/       - $XDG_PUBLICSHARE_DIR
Templates/    - $XDG_TEMPLATES_DIR
Videos/       - $XDG_VIDEOS_DIR

# hidden

.cache/       - $XDG_CACHE_HOME
.config/      - $XDG_CONFIG_HOME
.local/
├── bin/      - $XDG_BIN_HOME (not mentioned in the spec but de-facto standard)
├── share/    - $XDG_DATA_HOME (some apps put their config here)
└── state/    - $XDG_STATE_HOME
```

### Sensible default $HOME directories

```
Desktop/                - $XDG_DESKTOP_DIR
Downloads/              - $XDG_DOWNLOAD_DIR
Public/                 - $XDG_PUBLICSHARE_DIR
Files
├── Documents/          - $XDG_DOCUMENTS_DIR 
└── Templates/          - $XDG_TEMPLATES_DIR
Projects
Media
├── Music/              - $XDG_MUSIC_DIR
├── Pictures/           - $XDG_PICTURES_DIR
└── Videos/             - $XDG_VIDEOS_DIR


.cache                  - $XDG_CACHE_HOME, user-specific non-essential (cached) data
.config                 - $XDG_CONFIG_HOME, user-specific configuration files
.local
├── bin/                - $XDG_BIN_HOME, user-specific executable files
├── state/              - $XDG_STATE_HOME, user-specific state data
└── share/              - $XDG_DATA_HOME, user-specific data files 
    ├── applications/
    ├── fonts/
    └── Trash/
```

The remaining XDG directories usually is already handled by the system (in /etc/profile.d)
a colon separated of paths and for safety we should only append/prepend
paths here and not overwrite.

$XDG_DATA_DIRS     - /usr/local/share, usr/share (and others maybe set by the system)
$XDG_CONFIG_DIRS   - /etc/xdg (and others (and others may be set by the system)
$XDG_RUNTIME_DIRS  - (Not set in ubuntu 26.04, atleast for regular user)

## Shell runtime files

These are how bash runtime files are sourced and what they do.

> [!NOTE]
> These are the common defaults I'm aware of. Some distros add their own tweaks.


### How Bash rc files are sourced

```
interactive,     non-login,  - /etc/bash.bashrc, ~/.bashrc
non-interactive, non-login   - NONE
interactive,     login,      - /etc/profile, /etc/bash.bashrc, ~/.profile, ~/.bashrc
non-interactive, login       - /etc/profile, ~/.profile, ~/.bashrc
```

### The user profile (`~/.profile`)

This file doesn't belong to bash, and won't be sourced at all by bash if 
`~/.bash_profile` or `~/.bash_login` exists.

This file does two things:

- Include the `~/.bashrc` file (only if running bash); and
- Include user's private bin (by prepending `$HOME/bin`,`$HOME/.local/bin` to `$PATH`).

### The user config (`~/.bashrc`)


<details>
<summary>Sets bash history variables and options</summary>


```bash
# ...

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# ...
```
</details>


<details>
<summary>
  Determine if <code>$TERM</code> supports color output and if color prompt should be enabled
</summary>

```bash
# ...

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# ...
```
</details>

<details>
<summary>Sets terminal title</summary>


```bash
# ...

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# ...
```
</details>

<details>
<summary>
Enable color support for <code>ls</code> command, add handy aliases, and include `~/.bash_aliases`.
</summary>


```bash
# ...

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ...
```
</details>


<details>
<summary>
Enable programmable completion features.
</summary>


```bash
# ...

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ...
```
</details>









# Binary location

/usr/bin           - System packages binaries, symlinked to /bin
/usr/sbin          - root user binaries, symlinked to /sbin ("s" stands for "system")
/usr/local/bin     - packages installed manually, compiled from source,

~/.local/bin       - same idea with the above, user-specific packages


# fontconfig






# Desktop

/usr/share/applications      - system
~/.local/share/applications/ - user-specific


# Shells

Usually these shells are readily available
- sh, dash, bash
