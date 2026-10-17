# External completions directory - bash-completion

This directory `completions` is the place to put _external_ completion files,
i.e., ones not shipped with the bash-completion project.  They are loaded by
[bash-completion](https://github.com/scop/bash-completion) on demand.

> [!NOTE]
>
> The core `bash-completion` framework (<= 2.17) has provided also *completion
> files bundled with the bash-completion framework itself* in this directory,
> but we separated those files into `completions-core` and
> `completions-fallback`.  However, external completion providers should
> continue to install their completion files in `completions`.  The new
> directories `completions-core` and `completions-fallback` are internal
> directories intended to be used by the core bash-completion only.

The programmable completion for the command `<cmd>` is supposed to be provided
in the file `completions/<cmd>.bash`.  The implementation examples are found in
`completions-core`, which uses the latest bash-completion API (v3).  If you
want to make the completion file to work also with an older version of
`bash-completion`, you need to use the previous API of v2, which is contiuned
to be supported for now.  For examples with API v2, please reference the
completion files in `completions` of
[bash-completion-2.11](https://github.com/scop/bash-completion/releases/tag/2.11).

---

#### `<completionsdir>` For completion of specific commands:

From this directory, completions are automatically loaded on demand based on invoked commands' names

```bash
# /usr/share/bash-completion/completions (for me)
pkg-config --variable=completionsdir bash-completion
```

#### `<helpersdir>` Helper scripts used by completion:

```bash
# /usr/share/bash-completion/helpers (for me)
pkg-config --variable=helpersdir bash-completion
```

The completions  files in `<completionsdir>` can reference the helper script `<helpersdir>/<helper>` as:

```bash
${BASH_SOURCE[0]%/*}/../helpers/<helper>
```

#### `<startupdir>` Directory for startup files:

The startup file can be used to override `complete -D` settings by bash-completion.

A startup completion file can be added in the directory `<userdir>/startup`

A prefix of the form `[0-9][0-9][0-9]_` may be prepended to the filename of the startup files to control the loading order.

To override a existing startup file installed systemwide or shipped by us, you can put your own version with the same filename in `<userdir>/startup`

If you want to disable a startup completion file, you can use an empty file.

```bash
# undefined (for me)
# typical value according to the docs: /usr/share/bash-completion/startup
pkg-config bash-completion --variable=startupdir
```

#### `<compatdir>` Deprecated: Files here are loaded eagerly when bash_completion is loaded.

```bash
# /etc/bash_completion.d (for me)
pkg-config --variable=compatdir bash-completion
```
#### Override a completion shipped by bash-completion and/or install a new completion for a user account

You can install your own completion file for the command into an appropriate place. It will take precedence over the one shipped by us or the one installed systemwide. To install a completion on per user basis, put the completion file at `<userdir>/completions/<cmd>.bash`

#### `<userdir>`

The user directories are specified by the colon-separated `$BASH_COMPLETION_USER_DIR` (defaults to `$XDG_DATA_HOME/bash-completion`,

or `~/.local/share/bash-completion` if `$XDG_DATA_HOME` is not set).

They will be loaded automatically on demand when the respective command is being completed.

#### `<userfile>` eagerly loaded settings for user

```bash
# defaults to ~/.bash_completion
${BASH_COMPLETION_USER_FILE:-$HOME/.bash_completion}
```

Instead of preparing separate files for specific commands, you may write completion settings for specific commands directly in the user file.

When you want to modify the default completion setting set by `complete -D` (which is available in Bash >= 4.1), you can override it in the user file or in a user startup file.

If you want to use bash's default completion instead of one of ours, in the user file or in a user startup script, you can define something like this:

```shell
complete -o default -o bashdefault $cmd
```
