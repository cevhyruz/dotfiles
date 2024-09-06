local M = {}

local data = vim.fn.stdpath "data"

M.mappings = { -- {{{1
  i = {
    ["kj"]    = { "<Esc>",                      "switch to normal mode" },
  },
  n = {
    [";"] = { ":",                                  "quick commandline"              },
    ["j"] = { "gj",                                 "move down through wrapped line" },
    ["k"] = { "gk",                                 "move up through wrapped line"   },
 ["<Leader>s<Space>"] = { ":set spell!<CR>",        "toggle spell"    },
    ["<Space>"] = { ":set hls!<CR>",              "toggle highlight search" },
   },
  c = { ["kj"]    = { "<Esc>",                      "switch to normal mode"   },
        ["<C-h>"] = { "<Left>",                     "move cursor to left"   },
        ["<C-l>"] = { "<Right>",                    "move cursor to right"   },
        ["K"]     = { "<Up>",                       "go up in history"   },
        ["J"]     = { "<Up>",                       "go down cmdline history" },
  },
  v = {
    ["kj"]    = { "<Esc>",                      "switch back to normal mode"    },
  },

  x = {
    ["kj"]    = { "<Esc>",                      "switch to normal mode" }, 
  },
}

M.editor = { -- {{{1

  alt_esc = "kj", -- alternative <Esc> key.

  -- Sync options to a global value/variable
  link_opts = {
    ["tabspace"] = { "shiftwidth", "softtabstop", "tabstop" },
  },

  opts = {
    guicursor = "cr-c-ci:hor20,i-ve:ver25,r:hor20,o:hor50,n-v-sm:block,a:Cursor/lCursor",
    winbar = "%f",
    shortmess = vim.opt.shortmess:append("W"),
    colorcolumn = { 80 },
    laststatus = 3,
    showmode = false,
    clipboard = "unnamedplus",
    cursorline = true,
    -- indentation
    expandtab = true,
    smartindent = true,
    fillchars = { eob = " " },
    ignorecase = true,
    smartcase = true,
    mouse = "a",
    -- folds
    foldmethod = "marker",
    foldcolumn = "1",
    -- line numbers
    number = true,
    relativenumber = true,
    numberwidth = 2,
    ruler = true,
    ------------------
    signcolumn = "yes",
    splitbelow = true,
    splitright = true,
    termguicolors = true,
    timeoutlen = 400,
    undofile = true,
    -- interval for writing swap file to disk, also used by gitsigns
    updatetime = 250,
  },
}

return M
