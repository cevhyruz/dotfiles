# Bash Configuration Directory

This directory will be symlinked into `$XDG_CONFIG_HOME/bash` which is configured in
to be `~/.local/config/bash` See the [core/10-xdg.sh](core/10-xdg.sh) for more details.


## Directory Structure

```
config/bash/
├── aliases/               ← plugg-able custom aliases
├── completions/           ← plugg-able custom completions
│   ├── startup/           ← bash-completion startup
│   └── ...
├── core/                  ← foundational non-negotiable feature (sensible defaults)
├── libexec/               ← library executables for bash (downloading plugins, enabling features, etc..)
├── lib/                   ← library used throughout bash (can use bashlib)
├── plugins/               ← plugg-able custom session/command/tools improvements
│   ├── completion.bash
│   └── ...
├── themes/                ← visual styles directory
├── colorschemes/          ← colorschemes directory
├── bash_completion
├── bash_login
├── bash_logout
├── bash_profile
├── bashrc-minimal.bash    ← minamal default for when something went wrong
└── init.bash              ← initialize bash config

```

NOTES:
- All plugins/aliases/themes/colorschemes should not start on their own
  the bash core/ will provide handle api for starting them.


### aliases/

This directory follows the drop-in directory pattern where no files in the root of this directory
will be sourced at all, unless they are inside a subdirectory named enabled (aliases/enabled)
usually by symlinking.
Symlinking determines if the file will be sourced, this is only should be done by an enabled plugin
(for example sourcing `ng` aliases, when angular plugin is enabled).
Personal aliases should be written in `bash_aliases` which is sourced during the startup.

### completions/
Lazy-loaded user completions directory for [bash-completion](https://github.com/scop/bash-completion),
defined by `$BASH_COMPLETION_USER_DIR` variable by the bash-completion plugin
(See config/bash/plugins/bash-completion.bash).

### core/
These are my base configuration that are sourced chronologically.

### functions/
These are my convenient snippets that is too complicated to be an alias but too small
to be an executable script. It is like the second staging environment for soon-to-be executable scripts.
proof-of-concept and mostly non-portable initial function snippets should be in the bash_functions file
at the root of the bash confirugation directory sourced by the bashrc.

### lib/
Bash configuration libraries that is used throughout this bash configuration directory.
all library files in here should only be for managing the bash configuration.
If an external library (library in these dotfiles but outside of this bash directory)
is used here (mostly for libexec/ like the tui.sh) a symlink should be used.

### libexec/
Executable scripts used throughout managing bash configuration.
Used by the `dotfiles` command, files here should only be invoked by the dotfiles
dispatcher script (`dotfiles`).

### plugins/
These are configurations that extends the bash features.
custom session/command/tools improvements are in here.
This directory also follows the drop-in directory pattern.

### themes/
Collection of themes (See lib/theme.bash).
