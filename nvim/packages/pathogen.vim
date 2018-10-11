
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
" call add(g:pathogen_blacklist, 'YouCompleteMe')

" Initialize packages.
" ---------------------
  execute pathogen#infect('packages/{}')

" Generate help docs.
  call pathogen#helptags()


