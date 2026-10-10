# Directory Structure

These are my defined directory structure based on what's work for me

## Project Root

```
dotfiles/
├── _docs/                 ← __dotfiles docs
├── _packages/             ← My Favorite apps that I want to install
├── _scripts/              ← __dotfiles scripts (must NOT be in PATH)
├── _test/                 ← __dotfiles test suite
├── bin/                   ← user executables,
├── etc/                   ← System-wide config
├── config/                ← App specific config files
├── cron/                  ← Scheduled backup/sync or running a timely script
├── fonts/                 ← Custom fonts I want
├── personal/              ← My personal files (Music, Picture, Videos, Documents)
├── userscripts/           ← Custom browser scripts
├── bootstrap.sh
└── dotfiles.sh            ← Dotfiles dispatcher (will be symlinked to bin/)
```

### Dotfiles directories

Technically These directories are the only ones worth inside dotfiles

```
dotfiles/
├── config/             - $XDG_CONFIG_HOME (~/.config)
├── etc/                - $XDG_CONFIG_HOME
├── local/              - $XDG_BIN_HOME (~/.local/bin)
│   └── bin/
└── Templates/
```


```
Files
├── Documents/          - $XDG_DOCUMENTS_DIR 
└── Templates/          - $XDG_TEMPLATES_DIR
Projects
Media
├── Music/              - $XDG_MUSIC_DIR
├── Pictures/           - $XDG_PICTURES_DIR
└── Videos/             - $XDG_VIDEOS_DIR
```


### _docs/
Project documentation

### _scripts/
Contains administration scripts for dotfiles ONLY. examples are the subcommands
for the dotfiles dispacther (`dotfiles`) like:
  - installing fonts
  - creating symlinks
  - enabling/disabling a dotfiles feature

### _test/
The dotfiles test suite

### bin/

Custom executables that doesn't exactly fit the category of an app nor config.
this directory will be appended into `$PATH`

for example, a file browser script that depends on multiple tools
  like `fzf`, `less`, `vim`/`nvim`, `git`, `batcat`, `ag`, `rg`, `fdfind` etc..
this will now have a new name depending on it's purpose. for example as `lsf`.
which means "list files"

Note!: The `dotfiles` dispatcher command will also be here as it needed to be on `$PATH`

### config/
App specific configuration. this will be symlink to `$XDG_CONFIG_HOME` if it is set
or ~/.config.

### cron/
Scheduled jobs like backup/sync of dotfiles, upload/backup/sync of my
personal files (Music, Picture, Videos, Documents), and scheduled cleanup
of ~/Downloads.

### fonts/
Contains the necessary files for installing fonts.

### packages/
My favorite apps that I want to install.



bash/libexec
::  For exectables that are cross-shell

::  It is not included in the $PATH, thus calling them is straight-forward
    and verbose `cd $(~/.config/bash/libexec/icd)`

::  They are not meant to be typed in 

~/.local/libexec


~/.local/bin
:: Should be more of a general


```
~/Projects/dotfiles/
├── config/                ← config files, pre-processed by a render-template script and stowed into $XDG_CONFIG_HOME, ignoring any .tpl files and bin/.
│   ├── bash/
│   │   ├── config.tpl
│   │   ├── ignore
│   │   └── bin/           ← app-specific executables
│   ├── git/
│   │   ├── config.tpl
│   │   ├── ignore
│   │   └── bin/           ← app-specific executables
│   │       └── git-loglive
│   └── ...(other apps that has same structure)
├── bin/                   
│   └── dotfiles           ← Dotfiles dispatcher (dotfiles update, dotfiles stow...)
├── scripts/               ← Dotfiles exclusive scripts
│   ├── stow-away-config   ← Stow config, ignoring bin/ directory and any .tpl files
│   ├── stow-away-bin      ← If app has a /bin directory for every config/* then adding to path
│   └── render-template    ← Render a config file from a template file
├── userscripts/           ← Custom browser scripts
│   └── install.sh      
├── templates/             ← Custom templates
├── packages/              ← My Favorite apps that I want to install
│   └── install.sh      
├── packages/              ← My Favorite apps that I want to install
│   ├── apt.txt
│   ├── snap.txt
│   ├── pnpm-global.txt
│   ├── cargo.txt
│   ├── wallpapers.txt     ← List of wallpaper URLS and where to save them (add management in the dotfiles dispatcher)
│   ├── install-fonts.sh   ← Install my favorite list of custom fonts
│   └── custom/
│       ├── docker.sh      ← needs repo setup, not just `apt install`
│       └── nodejs.sh      ← installs via nvm, not apt
├── cron/                  ← for scheduled backup/sync or running a timely script
├── bootstrap.sh           ← Bootstrap for setting up of dotfiles (must be posix)
├── teardown.sh            ← Removes the symlinks, leaves repo and $HOME back to pre-stow state
└── .stowrc
```


==================================================
To add: into bootstrapping
==================================================
- logging in for browser
- setting up git
- managing passwords in cli



==================================================
To add:
==================================================

(Reference Only)

- gnome extension list + dconf dump
- package lists to be installed, update especially those that is manually built.
  - what package manager should I use? should I manually built it?
- SSH known_hosts
- GPG keys
- Nautilus Bookmarks



==================================================
 Edge case issues with the current structure:
==================================================

1.) Apps that don't respect XDG at all


==================================================
Dotfiles dispatcher features:
==================================================

1.) Re-generates a template
2.) Scoping (single app or all)
3.) Information display
4.) Directly editing a config template, then auto re-generate on save
5.) Editing global variables that persists
6.) dry-run - see what happen when doing something.
7.) teardown - removes the symlinks, leaves repo and $HOME back to pre-stow state
8.) running tests, like dotfiles test
9.) managing userscripts
10.) Bash plugins management


==================================================
Projects Directory Structure
==================================================

``` 
Projects/
├── apps/             ← repo that I personally use
├── archive/          ← forgotten wont-fix projects
├── clients/          ← repo for commissioned projects
├── contrib/          ← repo that I contribute to
├── experiments/      ← repo of playground projects (mostly unfinished)
├── learning/         ← 
├── personal/         ← personal projects of mine, templates
├── reference/        ← repo that has modified (notes, comments) so I can understand it
└── ventures          ← repo for projects that may go into my portfolio (enteprise grade without clients)
```
