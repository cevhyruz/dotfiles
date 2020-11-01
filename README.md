# dotfiles
# inspired by Alrra, mathiasbynes

# Code Convention/style guide:
bash - http://google.github.io/styleguide/shellguide.html#quoting

# bash/bin/
  - for scripts that are either too large or too complicated to
    - be on bash/profile.d/functions.sh, where they are split
    - into multiple smaller functions.
  - they are loaded by creating a symbolic link to /usr/local/bin
    - which was already on the environment path by default.

  NOTE: they are not standalone scripts!

  Three layer IDE tmux, bash, nvim


# Please don't astray to what the real purpose of this Dotfiles

    Bash, TMUX, VIM
# - It should be an interactive, customizable IDE like for
#   Software Development inside for linux.

# Meaning, It packs as one big IDE so there should'nt be any
# portable parts of code, especially for scripts (aside from configs).

# This Dotfiles should be strictly modal!

# One setup file (setup necessary things)
# One package manager to rule them all. bash, tmux, vim/nvim etc.
# - maybe using curl or wget?

# One library/API to serve them all
# - Meaning, If I have to: I'll shamefully ripoff those existing
#   plugins out there, and customize them according to my needs

# since I'm being greedy. I should just rewrite and  reinvent everything!

# Interactive configuration: like spacemacs

# Interactive documentation/help using less/man/nvim/vim or should I just write
# my own? yeah, I'm greedy!


# maybe write my own commandline: as alternative to tmux's.

# Code convention:
# lol

# What goodies does an IDE has?
# maybe a browser?
# debugger?
# task runner?
# should support android development
