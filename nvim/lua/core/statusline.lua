local devicons = require "nvim-web-devicons"

local M = {}

local winbar = {
    segment_a = {'filename', 'fileicon', 'filetype'},
    segment_b = {'location', 'path'},
    segment_c = {'flags', 'notification'},
    segment_x = {'diagnostics'},
    segment_y = {'diff'},
    segment_z = {'branch'}
}

function get_hl(hl_group, name)
  return string.format("%%#%s# %s", hl_group, name)
end

local function winbar(config)
  local fname = vim.fn.expand("%")
  local fext = vim.fn.expand("%:e")
  local icon, icon_hl = devicons.get_icon(fname, fext, { default = true })

  -- local metadata = {
  --   filename = vim.fn.expand("%"),
  --   extension = vim.fn.expand("%:e"),
  --   icon = (select(1, devicons.get_icon()))
  -- }

  -- for _,bar in pairs(winbar) do
  --   for _,component in pairs(bar) do
  --     local build_segement = ""
  --   end
  -- end
end

vim.api.nvim_create_autocmd({ -- winleave
  "BufEnter", "BufLeave", "WinEnter", "CursorMoved", "CursorMovedI" }, {
  group = vim.api.nvim_create_augroup('winBarEvent', { clear = true }),
  callback = function()
    if #vim.api.nvim_win_get_config(0).relative > 0
      or vim.bo.filetype == "NvimTree" then
        return
    end
      vim.opt_local.winbar = winbar(winbar)
  end
})
