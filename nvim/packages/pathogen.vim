
" Temporary Blacklisted plugins.
let g:pathogen_blacklist = []
 call add(g:pathogen_blacklist, 'fzf.vim')
 call add(g:pathogen_blacklist, 'nerdtree-buffer-ops')
 call add(g:pathogen_blacklist, 'nerdtree-git-plugin')
 call add(g:pathogen_blacklist, 'unite.vim')
 call add(g:pathogen_blacklist, 'vifm.vim')
 call add(g:pathogen_blacklist, 'vim-airline')
 call add(g:pathogen_blacklist, 'vim-airline-themes')
 call add(g:pathogen_blacklist, 'vim-buffergator')
 call add(g:pathogen_blacklist, 'vim-scriptease')
 call add(g:pathogen_blacklist, 'vim-vinegar')

" Initialize packages.
" ---------------------
" maybe I should just point it to the dotfiles installation directory??
" but then I must add all packages as a submodule (which I think is absurd)
" and will bloat the dotfiles repository.
  execute pathogen#infect('packages/{}')


