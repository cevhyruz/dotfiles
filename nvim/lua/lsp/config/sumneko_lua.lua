-- https://github.com/sumneko/lua-language-server/wiki/Settings
return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      completion = {
        keywordSnippet = "Disable"
      },
      workspace = {
        library = {
          [ vim.fn.expand('$VIMRUNTIME/lua') ] = true,
          [ vim.fn.expand('config') .. '/lua' ] = true
        }
      }
    }
  }
}
