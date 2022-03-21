local Utils = require('modules/map_utils')
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<Space><Space>', Utils.lua_fn(function()
  print("I love lua")
end), opts)

keymap('i', '<Tab>', Utils.lua_expr(function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  else
    return '<C-x><C-n>'
  end
end), { expr = true })

-- easy mode switching
keymap( 'i', 'kj', '<Esc>', opts )
keymap( 'x', 'kj', '<Esc>', opts )
keymap( 'c', 'kj', '<C-c>', opts )
keymap( 'v', 'kj', '<Esc>', opts )

-- vertical command line navigation (history)
keymap( 'c', 'K', '<Up>', opts )
keymap( 'c', 'J', '<Down>', opts )

-- horizontal command line navigation
keymap( 'c', '<C-h>', '<Left>', opts )
keymap( 'c', '<C-l>', '<Right>', opts )

-- scrolling increment by 3
keymap( 'n', '<C-e>', '3<C-e>', opts )
keymap( 'n', '<C-y>', '3<C-y>', opts )

-- quick commandline
keymap( 'n', ';', ':', opts )

-- easy navigation for wrapped-lines
keymap( 'n', 'j', 'gj', opts )
keymap( 'n', 'k', 'gk', opts )

-- plugin specific
keymap( 'n', '<C-n>', ':NERDTreeToggle<CR>', opts )

-- split navigation
-- TODO: make this tmux aware
keymap( 'n', '<C-k>', '<C-w><C-k>', opts )
keymap( 'n', '<C-j>', '<C-w><C-j>', opts )
keymap( 'n', '<C-l>', '<C-w><C-l>', opts )
keymap( 'n', '<C-h>', '<C-w><C-h>', opts )
keymap( 'n', '<C-j>', '<C-w><C-j>', opts )

keymap( 'n', '<C-j>', '<C-w><C-j>', {
  desc = function()
    print("love lua")
  end
})

--function _G:NavigateSplit()
  --if empty
--end

function _G:Reload()
  for name in pairs(package.loaded) do
    if name:match('^cevhyruz') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  print('reloaded')
end

vim.api.nvim_set_keymap('n', '<Leader>r', ':lua Reload()<CR>', { noremap = true })

-- commands
vim.cmd('command! Reload lua Reload()')
