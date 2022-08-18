local devicons = require "nvim-web-devicons"
local nvimtree = require "nvim-tree"

-- return a colored icon
local function fileicon()
  local file = vim.fn.expand("%s:t:r")
  local filename = vim.fn.expand("%")
  local extension = vim.fn.expand("%:e")
  local icon, icon_highlight_group = devicons.get_icon(filename, extension)

  if icon == nil and icon_highlight_group == nil then
    icon = nvimtree.config.renderer.icons.glyphs.default
    icon_highlight_group='DevIconDefault'
  end

  local _, color = devicons.get_icon_color(file, extension)
  if color == nil then color = "#6d8086" end

  vim.api.nvim_set_hl(0, icon_highlight_group..'WinBar', {
    fg = color,
    bold = true
  })

  return "%#"..icon_highlight_group .. "WinBar# " .. icon .. " "
end

local function lsp()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError# " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation# " .. count["info"]
  end

  return errors .. warnings .. hints .. info .. "%#Normal#"
end

local function filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" then
    return "[No Name] "
  end
  return fname .. " "
end

-- return path where the file lives.
local function filepath()
  if vim.fn.expand("%:t") == "" then
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end
  local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
  vim.api.nvim_set_hl(0, 'filePathWinBar', {
    fg = "#8a8a8a"
  })
  if fpath == "" or fpath == "." then
    return " "
  end
  return "%#filePathWinBar#" .. fpath
end

local function filetype()
  return string.format(" %s ", vim.bo.filetype)
end

local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end

Bar = {}

Bar.statusline = function()
  return table.concat {
    fileicon(),
    "%#StatusLine#",
    "%=%#StatusLineExtra#",
    filetype(),
    lineinfo(),
  }
end

function Bar.winBar()
  return table.concat {
    fileicon(),
    "%#Normal#",
    filename(),
    filepath(),
    "%=%#StatusLine#",
    lsp(),
  }
end


vim.api.nvim_create_autocmd({
  "BufEnter", "BufLeave", "WinEnter", "WinLeave", "CursorMoved", "CursorMovedI" }, {
  group = vim.api.nvim_create_augroup('winBarEvent', { clear = true }),
  callback = function()
    if #vim.api.nvim_win_get_config(0).relative > 0 then
      return
    end

    if vim.bo.filetype == "NvimTree" then
      return
    end

    if vim.bo.filetype == "qf" then
      return
    end

    vim.opt_local.winbar = Bar.winBar()
    vim.opt_global.statusline = Bar.statusline()
  end
})

vim.opt.laststatus = 3
