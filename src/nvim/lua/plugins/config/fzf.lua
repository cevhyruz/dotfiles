local fzf = {}

fzf.config = {}

fzf.specs = {
  cmd = {
    "FZF", "Buffers", "Files", "Ag",
  },

  dependencies = { "junegunn/fzf.vim" },

  init = function()
    vim.cmd [[ cnoreabbrev f FZF<CR> ]]
  end,

  config = function()
    vim.g.fzf_action = {
      ['ctrl-h'] = 'topleft vsplit',
      ['ctrl-n'] = 'botright split',
      ['ctrl-p'] = 'topleft split',
      ['ctrl-l'] = 'botright vsplit',
      ['alt-h']  = 'leftabove vsplit',
      ['alt-j']  = 'belowright split',
      ['alt-k']  = 'aboveleft split',
      ['alt-l']  = 'rightbelow vsplit',
      ['alt-t']  = 'tab split'
    }
    vim.g.fzf_colors = {
  fg      = { "fg", "Visual" },
  bg      = { "bg", "Visual" },
  hl      = { "fg", "Comment" },
  ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
  ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
  ["hl+"] = { "fg", "Statement" },
  info    = { "fg", "PreProc" },
  border  = { "fg", "Ignore" },
  prompt  = { "fg", "Conditional" },
  pointer = { "fg", "Exception" },
  marker  = { "fg", "Keyword" },
  spinner = { "fg", "Label" },
  header  = { "fg", "Comment" }
}
  end
}

return fzf
