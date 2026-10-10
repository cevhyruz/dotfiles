# bashlib

A directory of libary files that makes bash scripting a breeze.
Symlinked into `${XDG_DATA_HOME}/bashlib` or usually `~/.local/share/bashlib/`.


## Usage

Use the `lib.bash` to import any of the lib files,
the `import_lib()` function makes sure that a library file is only sourced a single time.

```bash
source "${XDG_DATA_HOME:-$HOME/.local/share}/bashlib/import.bash"
import_lib [lib name]...
```

## Creating new library file (For me)

When creating new library file, please be mindful of these:

- **Avoid cross referencing libraries** -- This avoids coupling the libraries
themselves. Consumers of this library should own the integration of different
functions found here themselves.
