local M = {}

local hlsearch = require "components.hlsearch"
local spell = require "components.spell"

local runtest = require "components.runtest"
local lspbuf = vim.lsp.buf
local diags = vim.diagnostic

M.dotfiles_builtin = {
  -- see ':help diags.*'
  { 'n',   '<leader>f',      diags.open_float,           },
  { 'n',   '[d',             diags.goto_prev,            },
  { 'n',   ']d',             diags.goto_next,            },
  { 'n',   '<leader>q',      diags.setloclist,           },

  -- see   ':help vim.lsp.*'
  { 'n',   'gd',             lspbuf.definition,          },
  { 'n',   'gD',             lspbuf.declaration,         },
  { 'n',   'gi',             lspbuf.implementation,      },
  { 'n',   '<Leader>3',      lspbuf.document_highlight,  },
  { 'n',   'K',              lspbuf.hover,               },
  { 'n',   '<Leader><C-k>',  lspbuf.signature_help,      },
  { 'n',   '<Leader>rn',     lspbuf.rename,              },
  { 'n',   'gr',             lspbuf.references,          },
  { 'n',   '<Leader>ca',     lspbuf.code_action,         },
  { 'n',   '<Tab>',   '<Cmd>AerialToggle<CR><C-w>w' },

  -- visual-select recently pasted text
  { 'n',   'gp',             '`[v`]' },

  -- adjust indentation of  selected text
  { 'n',   '<Leader>H',      '`[V`]<' },
  { 'n',   '<Leader>L',      '`[V`]>' },

  -- easy mode switching
  { 'x',   'kj',             '<Esc>' },
  { 'i',   'kj',             '<Esc>' },
  { 'v',   'kj',             '<Esc>' },
  { 'c',   'kj',             '<C-c>' },

  { {"x", "i", "v", "c" },   'kj',             '<Esc>' },

  -- command line navigation (history)
  { 'c',   'K',              '<Up>' },
  { 'c',   'J',              '<Down>' },
  { 'c',   '<C-h>',          '<Left>' },
  { 'c',   '<C-l>',          '<Right>' },
  -- scrolling (increment by 3)
  { 'n',   '<C-e>',          '3<C-e>' },
  { 'n',   '<C-y>',          '3<C-y>' },
  -- quick commandline
  { 'n',   ';',              ':' },
  -- quick text-reposition
  { 'n',   '<m-j>',          'Vmk:m+<cr>`zV'              },
  { 'n',   '<M-k>',          'Vmr:m-2<CR>`zV'             },
  { 'v',   '<M-j>',          ':m\'>+<CR>`<my`>mzgv`yo`z'  },
  { 'v',   '<M-k>',          ':m\'<-2<CR>`>my`<mzgv`yo`z' },
  -- easy navigation for wraped lines
  { 'n',   'j',              'gj' },
  { 'n',   'k',              'gk' },
  -- toggle nvimtree
  { 'n',   '<C-n>',          ':NvimTreeToggle<CR>' },
  -- toggle hlsearch
  { 'n', '<Space>',          hlsearch },
  -- toggle spell
  { 'n', '<Leader>s<Space>', spell },
  -- quick execute.
  { 'n', '<F5>',             runtest }

}

function M.set_cmp_keys(cmp)
  return  {
    ['K'] = cmp.mapping.select_prev_item(),
    ['J'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping( cmp.mapping.select_prev_item(), { "i", "c" } ),
    ['<C-n>'] = cmp.mapping( cmp.mapping.select_next_item(), { "i", "c" } ),
    ['<C-y>'] = cmp.mapping( cmp.mapping.scroll_docs(-2),    { "i", "c" } ),
    ['<C-e>'] = cmp.mapping( cmp.mapping.scroll_docs(2),     { "i", "c" } ),
    ['<C-Space>'] = cmp.mapping( cmp.mapping.complete(),     { "i", "c" } ),
    ['<C-c>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
    ['<Tab>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
  }
end

return M
