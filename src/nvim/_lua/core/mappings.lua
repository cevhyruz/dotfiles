local M = {}

local inc = 3

M.general = {
  i = { 
    ["kj"] = { "<Esc>", "switch to normal mode" },
  },

  n = {
    ["<C-e>"] = { inc .. "<C-e>",     "scroll down by 3 lines"       },
    ["<C-y>"] = { inc .. "<C-y>",    "scroll up by 3 lines"          },
    [";"]     = { ":",              "quick commandline"              },
    ["j"]     = { "gj",             "move down through wrapped line" },
    ["k"]     = { "gk",             "move up through wrapped line"   },
    ["<M-j>"] = { "Vmz:m+<cr>`zV",  "move the current line down"     },
    ["<M-k>"] = { "Vmz:m-2<CR>`zV", "move the current line up"       },
  },

  c = {
    ["kj"] = { "<Esc>", "switch to normal mode"   },
    ["K"]  = { "<Up>",  "go up cmdline history"   },
    ["J"]  = { "<Up>",  "go down cmdline history" },
  },

  t = {},

  v = {
    ["kj"]    = { "<Esc>",                      "switch to normal mode"         },
    ["<M-j>"] = { ":m\'>+<CR>`<my`>mzgv`yo`z",  "move the selected line/s down" },
    ["<M-k>"] = { ":m\'<-2<CR>`>my`<mzgv`yo`z", "move the selected line/s up"   },
  },

  x = {
    ["kj"] = { "<Esc>", "switch to normal mode" },
  },
}


M.nvimtree = {
  plugin = true,

    n = {
      -- toggle
      ["<C-n>"] = { "<cmd> NvimTreeToggle<CR>", "toggle nvimtree" },

      -- focus
      ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
    },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>rh"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>ph"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
}

return M
