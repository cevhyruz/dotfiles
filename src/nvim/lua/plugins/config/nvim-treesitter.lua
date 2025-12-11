
local M = {}

return M -- temporarily disable

M.options = {
  ensure_installed = "all",
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
}

M.specs = {
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = M.options
  config = function(_, opts)
    require "nvim-treesitter.configs".setup(opts)
  end
}



return M
