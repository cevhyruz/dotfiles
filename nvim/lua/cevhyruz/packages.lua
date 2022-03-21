local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tomasiser/vim-code-dark'
  use 'tpope/vim-surround'
  use 'tpope/vim-endwise'
  use {
    'ycm-core/YouCompleteMe',
    run = { 'python3 install.py' },
    config = function()
      vim.g.ycm_key_list_select_completion = {
        [1] = 'J',
        [2] = '<C-n>',
        [3] = '<Down>'
      }
      vim.g.ycm_key_list_previous_completion = {
        [1] = 'K',
        [2] = '<C-p>',
        [3] = '<Up>'
      }
    end
  }
  use {
    'airblade/vim-gitgutter',
    config = function()
      vim.g.gitgutter_map_keys = 0
      vim.g.gitgutter_sign_added = ' ┃'
      vim.g.gitgutter_sign_modified = ' ┃'
      vim.g.gitgutter_sign_removed = ' ┃'
      vim.g.gitgutter_sign_removed_first_line = ' ┃'
      vim.g.gitgutter_sign_modified_removed = ' ┃'
    end
  }
  use {
    'Yggdroot/indentLine',
    config = function()
      vim.g.indentLine_char = '┆'
      vim.g.indentLine_first_char = '|'
      vim.g.indentLine_color_term = 237
      vim.g.indentLine_indentLevel = 14
      vim.g.indentLine_showFirstIndentLevel = 1
      vim.g.indentLine_fileTypeExclude = {
        [1] = 'txt'
      }
      vim.g.indentLine_bufTypeExclude = {
        [1] = 'help',
        [2] = 'terminal'
      }
      vim.g.indentLine_bufNameExclude = {
        [1] = '_.*',
        [2] = 'NERD_Tree.*'
      }
    end
  }
  use 'easymotion/vim-easymotion'
  use 'blueyed/vim-diminactive'
  use 'itchyny/lightline.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-fugitive'
  use 'ryanoasis/vim-devicons'
  use 'dense-analysis/ale'
  use {
    'SirVer/ultisnips',
    config = {
      -- location of the snippet files.
      vim.cmd [[
        let g:UltiSnipsSnippetDirectories = [
        \ '/home/devs/Projects/dotfiles/nvim/UltiSnips',
        \ 'UltiSnips' ]
      ]]
    }
  }
  use {
    'aliou/bats.vim',
    ft = { 'bats' }
  }
  use {
    'majutsushi/tagbar',
    opt = true,
    cmd = {
      'Tagbar',
      'TagbarToggle'
    }
  }
  use {
    'junegunn/vader.vim',
    cmd = { 'Vader' },
    ft = { 'vader' }
  }
  use {
    'junegunn/fzf',
    run = ':call fzf#install()',
    requires = {{ 'junegunn/fzf.vim' }},
    config = function()
      vim.g.fzf_action = {
        ['ctrl-h'] = 'topleft vsplit',
        ['ctrl-n'] = 'botright split',
        ['ctrl-p'] = 'topleft split',
        ['ctrl-l'] = 'botright vsplit',
        ['alt-h'] = 'leftabove vsplit',
        ['alt-j'] = 'belowright split',
        ['alt-k'] = 'aboveleft split',
        ['alt-t'] = 'tab split',
      }
    end
  }
  use 'jiangmiao/auto-pairs'
  use 'preservim/nerdcommenter'
  use {
    'preservim/nerdtree',
    opt = true,
    cmd = {
      'NERDTree',
      'NERDTreeToggle'
    },
    setup = function()
      vim.api.nvim_set_keymap( 'n', '<C-n>', ':NERDTreeToggle<CR>',
      { noremap = true, silent = true } )

      vim.g.NERDTreeMapActivateNode = '<space>'
      vim.g.NERDTreeCascadeSingleChildDir = 1
      vim.g.NERDTreeQuitOnOpen = 1
      vim.g.NERDTreeMinimalUI = 1
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeIgnore = {
        [1] = '\\.git$',
        [2] = '\\~$',
        [3] = 'node_modules'
      }
      vim.g.NERDTreeWinSize = 35
    end
  }

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
