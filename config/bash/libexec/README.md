These executables are not included in the user's `$PATH` by design.
It must only be accssed through the `dotfiles` command which is by default
included in the `$PATH`

For example, if you want to run the audit script to check for any 
bash completion that wont work with `set -o nounset`:

```bash
dotfiles bash completion-nounset-audit
```
