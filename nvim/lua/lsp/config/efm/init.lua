local shellcheck = require "lsp.config.efm.shellcheck"
local javascript = require "lsp.config.efm.javascript"
local lua = require "lsp.config.efm.lua-format"

-- check this out https://github.com/creativenull/efmls-configs-nvim
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
