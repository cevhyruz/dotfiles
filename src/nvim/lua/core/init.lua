local opt = vim.opt

-- not a neovim option
vim.g.scrollspeed = 3  -- scroll speed using <C-e>, <C-y>

vim.g.mapleader = ","

opt.laststatus = 3
opt.showmode = false

opt.clipboard = "unnamedplus"
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = false

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns.
opt.updatetime = 250

-- go to previous/next line wiht h,l,left,right when cursor
-- reaches end/beginning of line.
opt.whichwrap:append "<>[]hl"

--- AutoCommands ---
local autocmd = vim.api.nvim_create_autocmd

-- don't list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end
})

--- User commands ---
local new_cmd = vim.api.nvim_create_user_command
