local shellcheck = require('lsp.config.efm.shellcheck')
local lua = require('lsp.config.efm.lua-format')
local javascript = require('lsp.config.efm.javascript')

return {
  init_options = {
    documentFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true
  },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      sh = { shellcheck },
      lua = { lua },
      javascript = { javascript,  }
    }
  }
}
