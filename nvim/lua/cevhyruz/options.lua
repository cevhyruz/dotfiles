vim.g.scriptencoding = 'utf8'
vim.g.mapleader = ','
vim.cmd [[ colorscheme codedark ]]

vim.o.clipboard = "unnamed,unnamedplus"
vim.o.updatetime = 100
vim.o.ttimeout = 50
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.showbreak = "\\u21b3" -- ↳

vim.opt.listchars = {
  trail = "~",
  tab = "\\u25b8\\ ",   -- \▸\ 
  extends = "\\u276f",  -- ❯
  precedes = "\\u276e", -- ❮
  nbsp = "\\u2423"      -- ␣
}
vim.bo.undofile = true

vim.o.splitbelow = true
vim.o.splitright = true
vim.wo.wrap = false
vim.wo.signcolumn = 'yes'

vim.o.smartcase = true
vim.o.ignorecase = true

vim.bo.smartindent = true
vim.bo.cindent = true

vim.bo.expandtab = true
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

vim.o.mouse = 'a'

vim.wo.list = true
vim.o.guicursor = "cr-c-ci:hor20,i-ve:ver25,r:hor20,o:hor50,n-v-sm:block,a:Cursor/lCursor"
