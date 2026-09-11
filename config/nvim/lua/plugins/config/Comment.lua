local M = {}

M.specs = {
  opts = {},
  lazy = false,
  config = function()
    require"Comment".setup()
  end
}

return M
