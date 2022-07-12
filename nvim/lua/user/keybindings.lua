local M = {}

M.LSP_KEY =  {
    diagnostic = {
      -- Diagnostic. See ':help vim.diagnostic.*'
      { '<leader>f', 'open_float()', { noremap = true } },
      { '[d',        'goto_prev()',  { noremap = true } },
      { ']d',        'goto_next()',  { noremap = true } },
      { '<leader>q', 'setloclist()', { noremap = true } },
    },
    -- LSP. see ':help vim.lsp.*'
    lsp = {
      { 'gd',         'buf.definition()',     { noremap = true } },
      { 'gD',         'buf.declaration()',    { noremap = true } },
      { 'gi',         'buf.implementation()', {} },
      { 'K',          'buf.hover()',          {} },
      { '<C-k>',      'buf.signature_help()', {} },
      { '<leader>rn', 'buf.rename()',         {} },
      { 'gr',         'buf.references()',     {} },
      { '<leader>ca', 'buf.code_action()',    {} },
    },
}

M.set_cmp_mapping = function(cmp)
  return {
    ['K'] = cmp.mapping.select_prev_item(),
    ['J'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping(
        cmp.mapping.select_prev_item(),
        { "i", "c" }
    ),
    ['<C-n>'] = cmp.mapping(
        cmp.mapping.select_next_item(),
        { "i", "c" }
    ),
    ['<C-y>'] = cmp.mapping(
        cmp.mapping.scroll_docs(-2),
        { "i", "c" }
    ),
    ['<C-e>'] = cmp.mapping(
        cmp.mapping.scroll_docs(2),
        { "i", "c" }
    ),
    ['<C-Space>'] = cmp.mapping(
        cmp.mapping.complete(),
        { "i", "c" }
    ),
    ['<C-c>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
  }
end

M.LOCAL_KEYS =  {
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
  },
  -- quick execute.
  { 'n', '<F5>',
    function()
      local shebang = vim.inspect( vim.api.nvim_buf_get_lines(0, 0, 1, false))
      if vim.fn.expand('%:e') or shebang  ~= '(bash|sh)' then
        vim.api.nvim_command(string.format('!./%s', vim.fn.expand('%')))
      end
    end
  }
}

return M
