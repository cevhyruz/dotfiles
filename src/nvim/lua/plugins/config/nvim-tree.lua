local M = {}

function on_attach(bufnr)
  local api = require "nvim-tree.api"
  api.config.mappings.default_on_attach(bufnr)

  -- LSP Rename File Hook
  if api.events and api.events.Event and api.events.Event.FileRenamed then
    print('working??')
    api.events.subscribe(api.events.Event.FileRenamed, function(data)
      api.events.subscribe(api.events.Event.FileRenamed, function(data)
        local old_name = data.old_name
        local new_name = data.new_name

        local params = {
          files = {
            {
              oldUri = vim.uri_from_fname(old_name),
              newUri = vim.uri_from_fname(new_name),
            }
          }
        }

        vim.lsp.buf_request(0, "workspace/willRenameFiles", params, function(err, res)
          if err then
            vim.notify("LSP Rename File error: " .. err.message, vim.log.levels.ERROR)
            return
          end
          vim.lsp.util.apply_workspace_edit(res, "utf-8")
        end)
      end)
    end)
  end


  local function map_opts(desc)
    return {
      desc = "nvim-tree" .. " " .. desc,
      buffer = bufnr,
      noremap = true,
      nowait = true,
    }
  end
  vim.keymap.set("n", "?",       api.tree.toggle_help,   map_opts("Help"))
  vim.keymap.set("n", "<Space>", api.node.open.edit,     map_opts("Edit"))
  vim.keymap.set("n", "l",       api.node.open.edit,     map_opts("Edit"))
  vim.keymap.set("n", "h",       api.node.open.edit,     map_opts("Edit"))
  vim.keymap.set("n", "v",       api.node.open.vertical, map_opts("Edit"))
end

M.options = {
  on_attach = on_attach,
  diagnostics = {
    enable = true
  },

  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = true
      }
    }
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    full_name = false,
    indent_markers = {
      enable = false,
      inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "└",
            none = " ",
          },
    },
    root_folder_modifier = ":t",
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "M",
          staged = "A", unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "?",
          ignored = "◌",
        },
      },
      git_placement = "signcolumn"
    }
  },
  hijack_netrw = false,
  --open_on_setup = false,
  --ignore_ft_on_setup = {
  --   "startify",
  --   "dashboard",
  --   "alpha",
  -- },
  open_on_tab = false,
  hijack_cursor = true,
  update_cwd = false,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  view = {
    width = 35,
  --  signcolumn = true,
    preserve_window_proportions = true,
    number = true,
    relativenumber = true,
    float = {
      enable = false,
      open_win_config = {
        relative = "editor",
        border = "none",
        width = 30,
        height = 30,
        row = 1,
        col = 1,
      },
    },
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  }
}

M.specs = {
  cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFocus" },
  init = function()
    vim.keymap.set("n", "<C-n>",
      ":NvimTreeToggle<CR>",
      { desc = "nvim-tree Toggle", silent = true }
    )
  end,
  opts = M.options,
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}

return M
