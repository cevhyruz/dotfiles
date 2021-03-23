# Dotfiles

This repository is a collection of configurations and settings for a
friction-free development environment.  Composed of tmux, neovim, bash, fzf,
and all other stuff to make development a breeze.

Heavily inspired by [Alrra's](https://github.com/Alrra/dotfiles)
and [mathiasbynens's](https://github.com/mathiasbynens/dotfiles) dotfiles.

## Setting up

Using your terminal if you don't have `git` installed yet:

```bash
bash -c "$(curl -LsS https://raw.github.com/alrra/dotfiles/main/src/os/setup.sh)"
```

Or if you already have `git` installed:

```bash
# clone this repository
git clone https://github.com/cevhyruz/dotfiles.git ~/Projects/dotfiles

# go into the repository
cd ~/Projects/dotfiles

# run setup script
./setup.sh
```

## Issues and Improvements

Spotted a bug? want to add that feature you want?
Please don't hesitate to file an issue using Github's issue tracker
or submit your pull request.

## Code convention

[Google Style guide](http://google.github.io/styleguide/shellguide.html#quoting)
for shell scripting.
