require('user.options')

require('user.maputils').init()

require('user.abbrev')
require('user.scroll')

require('user.statusline')

require('user.maputils')

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

local function open_win()
    buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.8)

    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded",
    }

    win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_win_set_option(win, "cursorline", true)
end

vim.api.nvim_create_user_command('Note', function()
  open_win()
end, {})
