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

vim.g.diminactive_enable_focus = 1

local group = vim.api.nvim_create_augroup('dimWindow', {clear = true})

vim.api.nvim_create_autocmd({"FocusGained", "WinEnter"}, {
  group = group,
  callback = function()
    vim.api.nvim_command("highlight Normal guibg=#1E1E1E")
    vim.api.nvim_command("highlight SignColumn guibg=#1E1E1E")
    vim.api.nvim_command("highlight LineNr guibg=#1E1E1E")
  end
})

vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
  group = group,
  callback = function()
    vim.api.nvim_command("highlight Normal guibg=#222222")
    vim.api.nvim_command("highlight SignColumn guibg=#222222")
    vim.api.nvim_command("highlight LineNr guibg=#222222")
  end
})
