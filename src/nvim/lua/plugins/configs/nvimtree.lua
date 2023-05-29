local options = {
  on_attach = on_attach,
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
        icons = {
              edge = "│",
              item = "│",
            corner = "╰",
              none = " ",
          },
    },
    root_folder_modifier = ":t",
    icons = {
      padding = " ",
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
      git_placement = "after"
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
  hijack_cursor = false,
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
    -- height = 30,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = true,
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

return options
