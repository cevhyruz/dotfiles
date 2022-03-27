local Utils = require('modules/map_utils')

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

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

-- quick line arrange
keymap( 'n', '<m-j>', 'mz:m+<cr>`z', opts )
keymap( 'v', '<M-j>', ':m\'>+<CR>`<my`>mzgv`yo`z', opts )
keymap( 'n', '<M-k>', 'mz:m-2<CR>`z', opts )
keymap( 'v', '<M-k>', ':m\'<-2<CR>`>my`<mzgv`yo`z', opts )

-- easy navigation for wrapped-lines
keymap( 'n', 'j', 'gj', opts )
keymap( 'n', 'k', 'gk', opts )

-- reload config
keymap('n', '<Leader>r', Utils.lua_fn( function()
  for name in pairs(package.loaded) do
    if name:match('^cevhyruz') then
      package.loaded[name] = nil
    end
  end
    dofile(vim.env.MYVIMRC)
    print('config reloaded')
end), opts)

-- toggle hlsearch
keymap('n', '<Space>', Utils.lua_fn( function()
  if vim.go.hls then
    vim.go.hls = false
  else
    vim.go.hls = true
  end
end), opts)

-- toggle spell
keymap('n', '<Leader>s<Space>', Utils.lua_fn( function()
  if vim.wo.spell then
    vim.wo.spell = false
  else
    vim.wo.spell = true
  end
end), opts)

local function nkeymap(key, map)
  keymap('n', key, map, opts)
end

nkeymap('<C-n>', ':NvimTreeToggle<cr>' )
