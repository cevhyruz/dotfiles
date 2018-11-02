
" Temporary Blacklisted plugins.
  let g:pathogen_blacklist = []
" call add(g:pathogen_blacklist, 'YouCompleteMe')
" call add(g:pathogen_blacklist, 'ale')
" call add(g:pathogen_blacklist, 'fzf.vim')
" call add(g:pathogen_blacklist, 'indentLine')
 call add(g:pathogen_blacklist, 'neovim-vifm')
 call add(g:pathogen_blacklist, 'nerdcommenter')
" call add(g:pathogen_blacklist, 'nerdtree')
 call add(g:pathogen_blacklist, 'nerdtree-buffer-ops')
 call add(g:pathogen_blacklist, 'nerdtree-git-plugin')
 call add(g:pathogen_blacklist, 'syntastic')

" YCM modules.
" call add(g:pathogen_blacklist, 'tlib_vim')
" call add(g:pathogen_blacklist, 'vim-addon-mw-utils')

" call add(g:pathogen_blacklist, 'ultisnips')
 call add(g:pathogen_blacklist, 'unite.vim')
 call add(g:pathogen_blacklist, 'vifm.vim')
 call add(g:pathogen_blacklist, 'vim-airline')
 call add(g:pathogen_blacklist, 'vim-airline-themes')
 call add(g:pathogen_blacklist, 'vim-buffergator')
 call add(g:pathogen_blacklist, 'vim-code-dark')
" call add(g:pathogen_blacklist, 'vim-devicons')

 call add(g:pathogen_blacklist, 'vim-easymotion')
 call add(g:pathogen_blacklist, 'vim-eunuch')
 call add(g:pathogen_blacklist, 'vim-fugitive')
" call add(g:pathogen_blacklist, 'vim-gitgutter')
 call add(g:pathogen_blacklist, 'vim-multiple-cursors')
 call add(g:pathogen_blacklist, 'vim-scriptease')
 call add(g:pathogen_blacklist, 'vim-showmarks')
 call add(g:pathogen_blacklist, 'vim-snipmate')
 call add(g:pathogen_blacklist, 'vim-surround')
 call add(g:pathogen_blacklist, 'vim-vinegar')


" Initialize custom location for packages.
" ----------------------------------------
  execute pathogen#infect('/home/devs/packages/{}')

" Generate helptags for plugins.
  call pathogen#helptags()
