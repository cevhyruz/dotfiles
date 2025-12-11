local M = {}

M.specs = {
  config = function()
    print('file operations')
    require("lsp-file-operations").setup()
  end

  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Uncomment whichever supported plugin(s) you use
    "nvim-tree/nvim-tree.lua",
    -- "nvim-neo-tree/neo-tree.nvim",
    -- "simonmclean/triptych.nvim"
  }
}


return M
