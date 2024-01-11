local M = {}


M.specs = {
  main = "ibl",
  opts = {},
  config = function()
    require("ibl").setup()
  end
}



return M
