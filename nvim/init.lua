vim.g.scriptencoding = 'utf8'
vim.g.mapleader = ','
vim.cmd [[ colorscheme codedark ]]

vim.cmd [[ filetype plugin indent on ]]

require('cevhyruz/options')
require('cevhyruz/packages')
require('cevhyruz/keybindings')

-- abbreviations
vim.cmd('cnoreabb f FZF<CR>')
