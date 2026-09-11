local M = {}

M.specs = {
  config = function(_, opts)
    local nav = require("nvim-tmux-navigation")
    vim.keymap.set("n", "<C-h>", nav.NvimTmuxNavigateLeft,  {})
    vim.keymap.set("n", "<C-j>", nav.NvimTmuxNavigateDown,  {})
    vim.keymap.set("n", "<C-k>", nav.NvimTmuxNavigateUp,    {})
    vim.keymap.set("n", "<C-l>", nav.NvimTmuxNavigateRight, {})
  end
}


return M
