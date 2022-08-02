require('user.options')

require('user.maputils').init()

require('user.abbrev')
require('user.scroll')

require('user.statusline')

require('user.packages')

require('lsp')

-- require('user.note')

require('user.utils')

dofile(vim.fn.getenv('DOTFILES') .. '/localrc/localrc.lua')
