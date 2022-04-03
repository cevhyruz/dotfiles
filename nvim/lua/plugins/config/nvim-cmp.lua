local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  return
end

local kind_icons = {
           Text = "{  }",
         Method = "{ m }",
       Function = "{  }",
    Constructor = "{  }",
          Field = "{  }",
       Variable = "{  }",
          Class = "{  }",
      Interface = "{  }",
         Module = "{  }",
       Property = "{  }",
           Unit = "{  }",
          Value = "{  }",
           Enum = "{  }",
        Keyword = "{  }",
        Snippet = "{  }",
          Color = "{  }",
           File = "{  }",
      Reference = "{  }",
         Folder = "{  }",
     EnumMember = "{  }",
       Constant = "{  }",
         Struct = "{  }",
          Event = "{  }",
       Operator = "{  }",
  TypeParameter = "{  }"
}

cmp.setup {
  snippet = {
    expand = function(args)
        vim.fn['UltiSnips#Anon'](args.body)
    end,
  },

  mapping = {
    -- See ':help cmp.mapping.*' for details
    ['<C-p>']     = cmp.mapping.select_prev_item(),
    ['<C-n>']     = cmp.mapping.select_next_item(),
    ['<C-y>']     = cmp.mapping(cmp.mapping.scroll_docs(-2), { 'i', 'c' }),
    ['<C-e>']     = cmp.mapping(cmp.mapping.scroll_docs(2), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-c>']     = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
    ['<CR>']      = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  },

  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)

      vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
      vim_item.abbr = ' ' .. vim_item.abbr
      vim_item.menu = (vim_item.menu or '') .. ' '

      vim_item.menu = ({
        nvim_lsp = '[Lsp]',
        ultisnips = '[Snp]',
        buffer = '[Buf]',
        nvim_lua = '[Lua]',
        path = '[Pth]',
        spell = '[Spl]'
      })[entry.source.name]

      return vim_item
    end
  },

  sources = {
    { name = 'ultisnips' },
    { name = 'nvim_lsp'  },
    { name = 'path'      },
    { name = 'buffer'    },
    { name = 'cmdline'   },
    { name = 'spell'   },
  },

  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false
  },

  documentation = {
    border = {
      "╭", "─", "╮" , "│", "╯", "─", "╰", "│"
    }
  },

  experimental = {
    ghost_text = false,
    native_menu = false
  },

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  }),

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
}
