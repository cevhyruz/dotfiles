local M = {}

local data = vim.fn.stdpath "data"

M.mappings = { -- {{{1
  i = {
    ["kj"]    = { "<Esc>",                      "switch to normal mode" },
  },
  n = {
    [";"] = { ":",                                  "quick commandline"              },
    ["<m-l>"] = { "8zl",                            "quick repeatable right horizontal scroll"              },
    ["<m-h>"] = { "8zh",                            "quick repeatable left horizontal scroll"              },
    [";w"] = { ":w<CR>",                            "quick save"              },
    ["vv"] = { "V",                                 "visual line"              },
    ["<m-j>"] = { "mz:m+<CR>`z",                    "move current line downward"              },
    ["<m-k>"] = { "mz:m-2<CR>`z",                   "move current line upward"              },
    ["<C-e>"] = { "4<C-e>",                         "quick scrolling"              },
    ["<C-y>"] = { "4<C-y>",                         "quick scrolling"              },
    ["j"] = { "gj",                                 "move down through wrapped line" },
    ["k"] = { "gk",                                 "move up through wrapped line"   },
    ["<Leader>s<Space>"] = { ":set spell!<CR>",     "toggle spell"    },
    ["<Leader>w<Space>"] = { ":set wrap!<CR>",      "toggle wrap"    },
    ["<Space>"] = { ":set hls!<CR>",                "toggle highlight search" },
   },
  c = { ["kj"]    = { "<Esc>",                      "switch to normal mode"   },
        ["<C-h>"] = { "<Left>",                     "move cursor to left"   },
        ["<C-l>"] = { "<Right>",                    "move cursor to right"   },
        ["K"]     = { "<Up>",                       "go up in history"   },
        ["J"]     = { "<Up>",                       "go down cmdline history" },
  },
  v = {
    ["kj"]    = { "<Esc>",                      "switch back to normal mode"    },
    ["<m-j>"] = { ":m'>+<cr>`<my`>mzgv`yo`z",  "move selected line downward"              },
    ["<m-k>"] = { ":m'<-2<cr>`>my`<mzgv`yo`z", "move current line upward"              },
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
    wrap = 'nowrap',
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
    redrawtime = 10000, -- https://github.com/prabirshrestha/vim-lsp/issues/786
    undofile = true,
    -- interval for writing swap file to disk, also used by gitsigns
    updatetime = 250,
  },
}

return M
