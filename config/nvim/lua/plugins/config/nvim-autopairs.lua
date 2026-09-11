local M = {}

M.specs = {
  event = "InsertEnter",
  opts = {},
  config = function()
    require"nvim-autopairs".setup()
  end
}


return M
