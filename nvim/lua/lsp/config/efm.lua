return {
  init_options = {
    documentFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true
  },
  settings = {
    rootMarkers = {".git/"},
    languages = {
      sh = {
        {
          lintCommand = 'shellcheck --format=gcc -x -',
          lintStdin = true,
          lintFormats = {
            '%f:%l:%c: %trror: %m',
            '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m'
          },
          formatCommand = 'shfmt -ci -bn -s -i ' .. vim.bo.shiftwidth,
          formatStdin = true
        }
      },
      lua = {
        {
          formatCommand = 'lua-format -i', formatStdin = true
        }
      },
      vim = {
        {
          lintCommand = 'vint --warning',
          lintStdin = true,
          lintFormats = {
            '%f:%l:%c: %trror: %m',
            '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m'
          },
        }
      }
    }
  }
}
