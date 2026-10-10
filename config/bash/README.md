==================================================
Bash Directory (config/bash)
==================================================

```bash
config/bash/
├── aliases/               ← plugg-able custom aliases
├── completions/           ← plugg-able custom completions
│   ├── startup/               ← bash-completion startup
│   └── ...
├── core/                  ← foundational non-negotiable feature (sensible defaults)
├── libexec/               ← library executables for bash (downloading plugins, enabling features, etc..)
├── lib/                   ← library used throughout bash (can use bashlib)
├── plugins/               ← plugg-able custom session/command/tools improvements
│   ├── completion.bash        ←
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


# ==================================================

