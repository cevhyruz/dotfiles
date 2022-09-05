local devicons = require "nvim-web-devicons"
local nvimtree = require "nvim-tree"


local current_file = vim.fn.expand("%")
local current_file_ext = vim.fn.expand("%:e")

local function init()
end

-- local config = {
--   file_name = { icon, hl_group } =devicons.get_icon(current_file, current_file_ext, { default = true })
--
--  devicons.get_icon(current_file, current_file_ext, { default = true }) }
  
  -- icons = {
  --   file_name = select(1, devicons.get_icon(current_file, current_file_ext, { default = true })),
    file_path = nvimtree.config.renderer.icons.glyph.folder.open,
  -- },
  -- hl_groups = {
  --   file_name = select(2, devicons.get_icon(current_file, current_file_ext, { default = true })),
  --   file_path = "",
  -- }
}

local function fileicon()
  local fname = vim.fn.expand("%")
  local fext = vim.fn.expand("%:e")

  local fname = vim.fn.expand "%:t"
  if fname == "" then
    return "[No Name] "
  end
  return string.format("%s %%m ", fname)
end

local function filepath()
  local file_path_icon = nvimtree.config.renderer.icons.glyph.folder.open
  if vim.fn.expand("%:t") == "" then
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end
  local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
  if fpath == "" or fpath == "." then
    return ""
  end
  return "%#NvimTreeFolderName#" .. fpath
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
    vcs(),
    lsp(),
  }
end




-- NvimTreeNormal
-- NvimTreeGitDirty
-- NvimTreeGitStaged
-- NvimTreeGitMerge
-- NvimTreeGitRenamed
-- NvimTreeGitNew
-- NvimTreeGitDeleted
-- NvimTreeGitIgnored

vim.api.nvim_create_user_command('Foobar', function()

  local explorer = require('nvim-tree.core').get_explorer()
  local log = require('nvim-tree.log')

  for _, node in pairs(explorer.nodes) do
    -- if node.absolute_path == vim.fn.expand(%s)
    -- log.line("dev", "%s", vim.inspect(node))
    -- print(string.format("%s - %s",node.absolute_path, node.git_status))
    print(vim.inspect(node))
  end
end, {})
