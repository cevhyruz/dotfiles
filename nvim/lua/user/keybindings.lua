local function_keys = {

  -- reload config
  { 'n', '<Leader>r',
    function()
      for name in pairs(package.loaded) do
        if name:match('^cevhyruz') then
          package.loaded[name] = nil
        end
      end
      print('config reloaded')
      dofile(vim.env.MYVIMRC)
    end
  },

  -- toggle hlsearch
  { 'n', '<Space>',
    function()
      if vim.go.hls then
        print('disabled hlsearch')
        vim.go.hls = false
      else
        print('enabled hlsearch')
        vim.go.hls = true
      end
    end
  },

  -- toggle spell
  { 'n', '<Leader>s<Space>',
    function()
      if vim.wo.spell then
        vim.wo.spell = false
          print('disabled spell')
      else
        vim.wo.spell = true
        print('enabled spell')
      end
    end
  }
}

local mapping_keys =  {

  -- easy mode switching
  { 'i', 'kj', '<Esc>' },
  { 'x', 'kj', '<Esc>' },
  { 'c', 'kj', '<C-c>' },
  { 'v', 'kj', '<Esc>' },

  -- vertical command line navigation (history)
  { 'c', 'K', '<Up>' },
  { 'c', 'J', '<Down>' },

  -- horizontal command line navigation
  { 'c', '<C-h>', '<Left>' },
  { 'c', '<C-l>', '<Right>' },

  -- scrolling (increment by 3)
  { 'n', '<C-e>', '3<C-e>' },
  { 'n', '<C-y>', '3<C-y>' },

  -- quick commandline
  { 'n', ';', ':' },

  -- quick relocate (current line)
  { 'n', '<m-j>', 'mz:m+<cr>`z' },
  { 'n', '<M-k>', 'mz:m-2<CR>`z' },

  -- quick relocate (selected)
  { 'v', '<M-j>', ':m\'>+<CR>`<my`>mzgv`yo`z' },
  { 'v', '<M-k>', ':m\'<-2<CR>`>my`<mzgv`yo`z' },

  -- easy navigation for wrapped lines
  { 'n', 'j', 'gj' },
  { 'n', 'k', 'gk' },

  -- toggle nvimtree
  { 'n', '<C-n>', ':NvimTreeToggle<CR>' }
}

require('modules.map_utils').setup(
  vim.tbl_deep_extend( 'keep', mapping_keys, function_keys )
)
