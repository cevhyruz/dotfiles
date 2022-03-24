require('cevhyruz/options')
require('cevhyruz/packages')
require('cevhyruz/keybindings')

require('package_config/git-gutter')

-- abbreviations
vim.cmd('cnoreabb f FZF<CR>')

-- TreeSitter
local config = require'nvim-treesitter.configs'
config.setup {
  ensure_installed = 'maintained', -- only use maintained parsers.
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

local lsp_installer = require('nvim-lsp-installer')
lsp_installer.on_server_ready(function(server)
  local opts = {}
  if server.name == 'sumneko_lua' then
    opts = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'use' }
          },
          --workspace = {
            -- Make the server aware of Neovim runtime files
            --library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
          --}
        }
      }
    }
  end
  server:setup(opts)
end)


-- completion
local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn['Ultisnips#Anon'](args.body)
      end
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['sumneko_lua'].setup {
    capabilities = capabilities
  }

-- @TODO: require localrc
