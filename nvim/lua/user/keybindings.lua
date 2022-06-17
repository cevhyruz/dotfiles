local M = {}

local lsp_keys = {
  diagnostic = {
    -- Diagnostic. See ':help vim.diagnostic.*'
    { '<leader>f', 'open_float()' },
    { '[d',        'goto_prev()'  },
    { ']d',        'goto_next()'  },
    { '<leader>q', 'setloclist()' },
  },
  -- LSP. see ':help vim.lsp.*'
  lsp = {
    { 'gd',         'buf.definition()'     },
    { 'gD',         'buf.declaration()'    },
    { 'gi',         'buf.implementation()' },
    { 'K',          'buf.hover()'          },
    { '<C-k>',      'buf.signature_help()' },
    { '<leader>rn', 'buf.rename()'         },
    { 'gr',         'buf.references()'     },
    { '<leader>ca', 'buf.code_action()'    },
  }
}

M.cmp_mapping = function(cmp)
  local map = cmp.mapping
  return  {
    -- See ':help cmp.mapping.*' for details
    ['K']     = map.select_prev_item(),
    ['<C-p>'] = map(map.select_prev_item(), { 'i', 'c' }),
    ['J']     = map.select_next_item(),
    ['<C-n>']  = map(map.select_next_item(), { 'i', 'c' }),
    ['<C-y>']     = map(map.scroll_docs(-2), { 'i', 'c' }),
    ['<C-e>']     = map(map.scroll_docs(2), { 'i', 'c' }),
    ['<C-Space>'] = map(map.complete(), { 'i', 'c' }),
    ['<C-c>']     = map({i = map.abort(), c = map.close()}),
    ['<CR>']      = map.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  }
end

local mapping_keys =  {
  -- easy mode switching
  { 'i', 'kj', '<Esc>' },
  { 'x', 'kj', '<Esc>' },
  { 'c', 'kj', '<C-c>' },
  { 'v', 'kj', '<Esc>' },

  -- command line navigation (history)
  { 'c', 'K',     '<Up>'    },
  { 'c', 'J',     '<Down>'  },
  { 'c', '<C-h>', '<Left>'  },
  { 'c', '<C-l>', '<Right>' },

  -- scrolling (increment by 3)
  { 'n', '<C-e>', '3<C-e>' },
  { 'n', '<C-y>', '3<C-y>' },

  -- quick commandline
  { 'n', ';', ':' },

  -- quick relocate (current line)
  { 'n', '<m-j>', 'mz:m+<cr>`z'                },
  { 'n', '<M-k>', 'mz:m-2<CR>`z'               },
  { 'v', '<M-j>', ':m\'>+<CR>`<my`>mzgv`yo`z'  },
  { 'v', '<M-k>', ':m\'<-2<CR>`>my`<mzgv`yo`z' },

  -- easy navigation for wrapped lines
  { 'n', 'j', 'gj' },
  { 'n', 'k', 'gk' },

  -- toggle nvimtree
  { 'n', '<C-n>', ':NvimTreeToggle<CR>' },

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
        vim.opt.spell = false
          print('disabled spell')
      else
        vim.opt.spell = true
        vim.opt.spelllang = { 'en_us' }
        print('enabled spell')
      end
    end
  }
}

local fn_table = {}

local function _register_fn(fn)
  table.insert(fn_table, fn)
  return #fn_table
end

local function lua_fn(fn)
  return string.format( ':lua require("%s").apply_function(%s)<CR>',
    'user.keybindings', _register_fn(fn))
end

-- call stored function keys
M.apply_function = function(id)
  fn_table[id]()
end

-- my custom keybindings
M.init = function()
  local opts = { noremap = true } for _,value in pairs(mapping_keys) do
    if type(value[3]) == 'function' then
      vim.api.nvim_set_keymap( value[1], value[2], lua_fn(value[3]), opts )
    else
      vim.api.nvim_set_keymap( value[1], value[2], value[3], opts)
    end
  end
end

-- Setup lsp keybindings
M.on_lsp_attach = function(bufnr)
  local opts = { noremap = true }
  -- diagnostic
  for _,value in pairs(lsp_keys.diagnostic) do
    vim.api.nvim_buf_set_keymap(
      bufnr, 'n', value[1], ':lua vim.diagnostic.' .. value[2] .. '<CR>', opts
    )
  end
  -- lsp
  for _,value in pairs(lsp_keys.lsp) do
    vim.api.nvim_buf_set_keymap(
      bufnr, 'n', value[1], ':lua vim.lsp.'.. value[2] ..'<CR>', opts
    )
  end
end

return M
