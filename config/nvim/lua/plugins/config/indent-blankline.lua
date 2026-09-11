local M = {}

M.specs = {
  main = "ibl",
  opts = {},
  config = function()
    -- require("ibl").setup()

local highlight = {
    "CursorColumn",
    "Whitespace",

}
require("ibl").setup {
    indent = { char = "│" },
    -- whitespace = {
    --     highlight = highlight,
    --     remove_blankline_trail = false,
    -- },
    scope = { enabled = false },
}
  end
}



return M
