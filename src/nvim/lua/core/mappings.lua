local M = {}

local sclspd = vim.g.scrollspeed

M.general = {
  i = {
    ["kj"] = { "<Esc>", "switch to normal mode" }, },

  n = {
    ["<C-e>"] = { sclspd .. "<C-e>", "scroll down"                    },
    ["<C-y>"] = { sclspd .. "<C-y>", "scroll up"                      },
    [";"]     = { ":",               "quick commandline"              },
    ["j"]     = { "gj",              "move down through wrapped line" },
    ["k"]     = { "gk",              "move up through wrapped line"   },
    ["<M-j>"] = { "Vmz:m+<cr>`zV",   "move the current line down"     },
    ["<M-k>"] = { "Vmz:m-2<CR>`zV",  "move the current line up"       },
    ["<Space>"] = { function()
      if vim.go.hlsearch then
        vim.go.hlsearch = false
      else
        vim.go.hlsearch = true
      end
    end, "toggle hlsearch"},

    ["<Leader>s<Space>"] = { function()
      if vim.wo.spell then
        vim.opt.spell = false
      else
        vim.opt.spell = true
        vim.opt.spelllang = { "en_us"}
      end
    end, "toggle spell"},

  },

  c = {
    ["kj"] = { "<Esc>", "switch to normal mode"   },
    ["K"]  = { "<Up>",  "go up cmdline history"   },
    ["J"]  = { "<Up>",  "go down cmdline history" },
  },

  v = {
    ["kj"]    = { "<Esc>",                      "switch back to normal mode"    },
    ["<M-j>"] = { ":m\'>+<CR>`<my`>mzgv`yo`z",  "move the selected line/s down" },
    ["<M-k>"] = { ":m\'<-2<CR>`>my`<mzgv`yo`z", "move the selected line/s up"   },
  },

  x = {
    ["kj"] = { "<Esc>", "switch to normal mode" },
  },
}

M.comment = {
  n = {
    ["<Leader>c"] = { function()
      print('should toggle commentary')
      require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment", },
  },

  v = {
    ["<Leader>c"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
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

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "find in current buffer" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "nvchad themes" },
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
