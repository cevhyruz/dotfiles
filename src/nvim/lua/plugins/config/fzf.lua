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
  end
}

return fzf
