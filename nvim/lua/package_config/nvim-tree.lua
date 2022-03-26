require('nvim-tree').setup {
  auto_close = true,
  hijack_cursor = false,
  auto_reload_on_write = true,
  view = {
    width = 35,
    height = 35,
    preserve_window_proportions = true,
    mappings = {
      list = {
        { key = '<Space>', action = 'edit' }
      }
    }
  },
  filters = {
    custom = { '.git', 'node_modules' },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  open_file = {
    quit_on_open = true,
    window_picker = {
      enable = false
    }
  },
  git = {
    enable = false,
    ignore = true,
    timeout = 500
  }
}
