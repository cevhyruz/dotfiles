
" Temporary Blacklisted plugins.
let g:pathogen_blacklist = []
 call add(g:pathogen_blacklist, 'nerdtree-git-plugin')
 call add(g:pathogen_blacklist, 'nerdtree-buffer-ops')
 call add(g:pathogen_blacklist, 'unite')
 call add(g:pathogen_blacklist, 'vim-vinegar')
 call add(g:pathogen_blacklist, 'vim-buffergator')
 call add(g:pathogen_blacklist, 'vim-nerdtree-syntax-highlight')

" Initialize packages.
" ---------------------
" maybe I should just point it to the dotfiles installation directory??
" but then I must add all packages as a submodule (which I think is absurd)
" and will bloat the dotfiles repository.
  execute pathogen#infect('packages/{}')


