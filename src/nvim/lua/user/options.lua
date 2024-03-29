vim.g.mapleader = ","

-- vim.opt.shellcmdflag = "-ic"
vim.opt.completeopt = { 'menu', "menuone", "noselect", }
vim.opt.termguicolors = true
vim.opt.shortmess:append("W")
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.foldlevel = 99
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cursorline = true
vim.opt.colorcolumn = '80'
vim.opt.clipboard = 'unnamed,unnamedplus'
-- vim.opt.updatetime = 100
-- vim.opt.ttimeoutlen = 50
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showbreak = '↳'
vim.opt.listchars = {
  trail = '~',
  tab = '▸ ',
  extends = '❯',
  precedes = '❮',
  nbsp = '␣'
}
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.mouse = 'a'
vim.opt.list = true
vim.opt.guicursor = 'cr-c-ci:hor20,i-ve:ver25,r:hor20,o:hor50,n-v-sm:block,a:Cursor/lCursor'
