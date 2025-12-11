-- These are the core default configuration.
local data = vim.fn.stdpath "data"
local M = {}

M.autocmd = { -- {{{1
  ["NoQuickfixBuffers"] = {
    events = { "FileType" },
    opts = {
      pattern = "qf",
      callback = function()
        vim.opt_local.buflisted = false
      end
    },
  },
}

M.freshinstall = { -- {{{1
  autoclose = true, -- autoclose lazy installer when done.
  messages = {
    "[ All done! Enjoy! ]",
  }
}

M.g = {
  mapleader = ",",
  scrollspeed = 3,  -- mouse and keyboard scrollspeed
  tabspace = 2,
}

-- plugin install path
M.paths = { -- {{{1
  lazy = data .. "/lazy/lazy.nvim",
}

M.mappings = { -- {{{
  -- key, mode, desc
  alt_esc = { "kj", {"insert", "visual"}, "switch back to normal mode" },
  -- modifier, keys
  navigation = {},

  modes = {
    n = {
      ["<C-e>"] = { vim.g.scrollspeed or "3" .. "<C-e>", "scroll down"         },
      ["<C-y>"] = { vim.g.scrollspeed or "3" .. "<C-y>", "scroll up"           },
      ["<C-l>"] = { "<C-w><C-l>",                        "go to right pane" },
      ["<C-h>"] = { "<C-w><C-h>",                        "go to left pane"  },
      ["<C-j>"] = { "<C-w><C-j>",                        "go to upper pane" },
      ["<C-k>"] = { "<C-w><C-k>",                        "go to lower pane" },
      ["<M-j>"] = { "Vmz:m+<cr>`zV",              "move the current line down"     },
      ["<M-k>"] = { "Vmz:m-2<CR>`zV",             "move the current line up"    },
    },
    c = {
      ["<C-h>"] = { "<Left>",                     "move cursor to left"   },
      ["<C-l>"] = { "<Right>",                    "move cursor to right"   },
    },
    v = {
      ["kj"]    = { "<Esc>",                      "switch back to normal mode"    },
      ["<M-j>"] = { ":m\'>+<CR>`<my`>mzgv`yo`z",  "move the selected line/s down" },
      ["<M-k>"] = { ":m\'<-2<CR>`>my`<mzgv`yo`z", "move the selected line/s up"},
    },
  },
}

M.editor = { -- {{{1

  -- alt <Esc> key, used in insert,command and visual
  alt_esc = "kj", -- alternative <Esc> key.

  -- Sync options to a global value/variable
  link_opts = {
    ["tabspace"] = { "shiftwidth", "softtabstop", "tabstop" }
  },

  opts = {
    -- guicursor = "cr-c-ci:hor20,i-ve:ver25,r:hor20,o:hor50,n-v-sm:block,a:Cursor/lCursor",
    -- guicursor = "c-ci:hor20,i-ve:ver25,r:hor20,o:hor50,n-v-sm:block,a:Cursor/lCursor",
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
