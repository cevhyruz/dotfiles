local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if fpath == "" or fpath == "." then
      return " "
  end
  return string.format("%%<%s", fpath)
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = { '' },
      winbar = { 'NvimTree' },
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  -- statusline
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch' },
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat' },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {'filetype'},
    lualine_z = {}
  },
  lualine_a = {},
  lualine_b = {'branch'},
  lualine_c = {'filename'},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
  -- winbar
  winbar = {
    lualine_a = {'fileicon'},
    lualine_b = {},
    lualine_c = {'filetype','filename', filepath},
    lualine_x = {'diff', 'diagnostics'},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filetype', 'filename', filepath},
    lualine_x = {'diff', 'diagnostics'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {}
}
