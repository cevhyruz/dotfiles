local M = {}

M.specs = {
  version = "*",
  -- event = "VeryLazy",
  config = function()
    require "nvim-surround".setup()
  end
}


return M
