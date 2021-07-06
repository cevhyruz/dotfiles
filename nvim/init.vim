if has('nvim')
  call plug#begin(stdpath('data') . '/plugged')
else
  call plug#begin('~/.vim/plugged')
endif
  " == [ Interfaces ] ==
  Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'ryanoasis/vim-devicons'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'Yggdroot/indentLine'
  Plug 'blueyed/vim-diminactive'
  Plug 'itchyny/lightline.vim'
  " == [ Syntax highlighting ] ==
  Plug 'aliou/bats.vim'
  Plug 'digitaltoad/vim-pug'
  Plug 'yuezk/vim-js'
  " == [ Themes ] ==
  Plug 'tomasiser/vim-code-dark'
  " == [ Linters ] ==
  Plug 'dense-analysis/ale'
  " == [ Completion ] ==
  Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
  " == [ Workflow tools ] ==
  Plug 'preservim/nerdcommenter'
  Plug 'tpope/vim-fugitive'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'SirVer/ultisnips'
  Plug 'majutsushi/tagbar'
  Plug 'junegunn/vim-easy-align'
  Plug 'easymotion/vim-easymotion'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'junegunn/vader.vim'
call plug#end()

" Plugin Settings
function! s:source_files(file)
  if filereadable(a:file)
    execute 'source' a:file
  endif
endfunction

call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/ale.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/devicons.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/diminactive.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/easy-align.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/fzf.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/gitgutter.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/indentline.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/nerdcommenter.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/nerdtree.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/startify.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/tagbar.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/ultisnips.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/plugin/ycm.vim'))

call s:source_files(expand('~/Projects/dotfiles/nvim/options.vim'))
call s:source_files(expand('~/Projects/dotfiles/nvim/mappings.vim'))

augroup change_cursor_shape
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"'
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[5 q"' |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
augroup END

" SECTION: Commands

if empty($TMUX)
  command! NavRight call vimrc#navigate('l')
  command! NavLeft  call vimrc#navigate('h')
  command! NavUp    call vimrc#navigate('k')
  command! NavDown  call vimrc#navigate('j')
  command! NavPrev  call vimrc#navigate('p')
else
  command! NavRight call vimrc#tmux_navigate('l')
  command! NavLeft  call vimrc#tmux_navigate('h')
  command! NavUp    call vimrc#tmux_navigate('k')
  command! NavDown  call vimrc#tmux_navigate('j')
  command! NavPrev  call vimrc#tmux_navigate('p')
endif

" SECTION: AutoCommands

augroup push_tab
  autocmd!
  autocmd TabLeave * let g:prev_tab = tabpagenr()
augroup END

augroup close_if_only_nerdtree
  autocmd!
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

function! s:reload_vimrc()
  let s:vimrc = expand($MYVIMRC)
  let s:prettify_nerdtree = expand('~/Projects/dotfiles/nvim/nerdtree_plugin/prettify.vim')
  if filereadable(expand(s:vimrc))
    execute ':source' s:vimrc
    call webdevicons#hardRefresh()
    execute ':source' s:prettify_nerdtree
    echom '[vimrc] config reloaded..'
  endif
endfunction

function! s:syn_stack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" SECTION: localrc

let s:local_vimrc = expand('~/Projects/dotfiles/localrc/local.nvimrc')
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif
