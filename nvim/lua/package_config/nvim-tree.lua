require'nvim-tree'.setup {
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
    exclude = { '.git', 'node_modules' }
  },
  open_file = {
    quit_on_open = true
  },
  git = {
    enable = false
  }
}
