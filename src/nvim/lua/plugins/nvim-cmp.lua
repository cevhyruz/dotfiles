local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  return
end

local kind_icons = {
           Text = "{  }",     Method = "{ m }",  Function = "{  }",
    Constructor = "{  }",      Field = "{  }",  Variable = "{  }",
          Class = "{  }",  Interface = "{  }",    Module = "{  }",
       Property = "{  }",       Unit = "{  }",     Value = "{  }",
           Enum = "{  }",    Keyword = "{  }",   Snippet = "{  }",
          Color = "{  }",       File = "{  }", Reference = "{  }",
         Folder = "{  }", EnumMember = "{  }",  Constant = "{  }",
         Struct = "{  }",      Event = "{  }",  Operator = "{  }",
  TypeParameter = "{  }"
}

cmp.setup {
  snippet = {
    expand = function(args)
        vim.fn['UltiSnips#Anon'](args.body)
    end,
  },
  mapping = require('user.keybindings').set_cmp_keys(cmp),
  formatting = {
    fields = {  'abbr', 'kind', 'menu' },
    format = function(entry, item)
      item.kind = kind_icons[item.kind] .. " ".. item.kind
      item.abbr = item.abbr
      item.menu = (item.menu or '') .. ' '
      item.menu = ({
        nvim_lsp = '[LSP]',    ultisnips = '[UltiSnips]',
          buffer = '[Buffer]',  nvim_lua = '[Lua]',
            path = '[Path]',     myspell = '[spell from myspell]'
      })[entry.source.name]
      return item
    end
  },
  sources = {
    { name = 'ultisnips' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'cmdline' },
    { name = 'myspell' },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false
  },
  window = {
    documentation = {
      border = {
        "╭", "─", "╮" , "│", "╯", "─", "╰", "│"
      }
    },
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    },
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

