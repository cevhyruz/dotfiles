local M = {}

M.specs = {
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd [[ colorscheme codedark ]]
  end
}


return M
