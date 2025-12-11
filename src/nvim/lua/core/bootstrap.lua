local M = {}

local Profile  = require "profiles"
local userconf = require "profiles.user"

-- Configure all or specific component.
-- @param: table | string, list/s of component to bootstrap.
-- @usage: require("bootstrap").setup(component)
function M:setup()
  if self ~= nil then
    return M[self]()
  end
  M.options()
  M.mappings(userconf.mappings)
  M.plugins()
  M.autocmd()
  M.highlight()
end

local function _echo(message)
  vim.api.nvim_command [[ redraw ]]
  vim.api.nvim_echo({{ message, "bold"}}, true, {})
end

function M:lazy(lazypath)
  _echo [[ Installing lazy.nvim ]]
  cmd = vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
  if vim.v.shell_error == 0 then
    return true
  else
    return false
  end
end

function M:autocmd()
  local autocmd = Profile.autocmd
  for group, entry in pairs(autocmd) do
    local opts = vim.tbl_deep_extend("force", entry["opts"], {
      group = vim.api.nvim_create_augroup(group, { clear = true })
    })
    vim.api.nvim_create_autocmd(entry["events"], opts)
  end
end

function M:mappings()
  for mode, mode_values in pairs(Profile.mappings and self or {}) do
    for keymap, keymap_info  in pairs(mode_values) do
      local opts = { desc = keymap_info[2] }
      vim.keymap.set(mode, keymap, keymap_info[1], opts)
    end
  end
end

function M:plugins()
  local freshinstall = false
  local lazypath = Profile.paths.lazy
  local plugins = require "plugins"

  if not vim.loop.fs_stat(lazypath) then
    if M:lazy(lazypath) then
      freshinstall = true
    end
  end

  vim.opt.rtp:prepend(lazypath)
  require"lazy".setup(
    plugins.setup(),
    { install = { colorscheme = { "morning", "habamax" } }, }
  )

  if freshinstall then
    vim.api.nvim_buf_delete(0, { force = true })
    _echo(Profile.freshinstall.messages[1])
  end
end

function M:options()
  for keytype, values in pairs({
     global = Profile.g,
    options = Profile.editor.opts }) do
    for key, val in pairs(values) do
      if keytype == "global" then
        vim.g[key] = val
      else
        vim.opt[key] = val
      end
    end
  end
  -- linked options
  for key, options in pairs(Profile.editor.link_opts) do
    for _, opts in pairs(options) do
      vim.opt[opts] = Profile.g.tabspace
    end
  end
end

function M:highlight()

  local hi_group = {
    WinBar = {  guifg = '#E0E0E0', guibg = '#303030', bold = false },
    StatusLine = {  guifg = '#E0E0E0', guibg = '#303030', bold = false },
    Folded = { guifg = '#9a9a9a', guibg = '#000000', bold = false },
    -- change this for bg
    Normal = { guifg = '#CBCBCB', guibg = '#000000', bold = false },
    NormalFloat = { guifg = '#CBCBCB', guibg = '#000000', bold = false },
    FoldColumn = { guifg = '#CBCBCB', guibg = '#000000', bold = false },
    SignColumn = { guifg = '#CBCBCB', guibg = '#000000', bold = false },
    WinSeparator = { guifg = '#2a2a2a', guibg = '#000000', bold = false },
    LineNr = { guifg = '#4a4a4a', guibg = '#000000', bold = false },
    IblIndent = { guifg = '#1a1a1a', guibg = '#000000', bold = false },
    EndOfBuffer = { guifg = '#1a1a1a', guibg = '#000000', bold = false },
    CursorLine = { guifg = '', guibg = '#111111', bold = false },
    -- LSP Diagnostics
    DiagnosticError = { guifg = '#FF5555', guibg = '', bold = false },
    DiagnosticWarn = { guifg = '#F1FA8C', guibg = '', bold = false },
    DiagnosticInfo = { guifg = '#8BE9FD', guibg = '', bold = false },
    DiagnosticHint = { guifg = 'red', guibg = '', bold = false }
  }

  for name, color in pairs(hi_group) do
    vim.api.nvim_set_hl(0, name, {
      fg = color.guifg,
      bg = color.guibg,
      bold = color.bold
    })
  end
end

return M
