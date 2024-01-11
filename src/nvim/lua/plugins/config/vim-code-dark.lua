local M = {}

M.specs = {
  lazy = false,
  init = function()
    vim.cmd [[ colorscheme codedark ]]
  end
}


return M
