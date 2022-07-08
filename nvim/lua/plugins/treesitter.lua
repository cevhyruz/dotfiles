local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

configs.setup {
  ensure_installed = 'all',
  sync_install = false,
  ignore_install = { '' },
  highlight = {
    enable = true,
    disable = { '' },
    additional_vim_regex_highlighting = false
  },
  indent = {
    enable = true,
    disable = { '' }
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  },  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {},
    -- termcolors = {} -- table of colour name strings
  }
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
