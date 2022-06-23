local M = {}

local fn_table = {}
local local_map = require('user.keybindings')

local function _register_fn(fn)
  table.insert(fn_table, fn)
  return #fn_table
end

local function _lua_fn(fn)
  return string.format( ':lua require("%s").apply_function(%s)<CR>',
    'user.maputils', _register_fn(fn))
end

-- call stored function keys
M.apply_function = function(id)
  fn_table[id]()
end

-- Setup my custom local keys on startup.
M.init = function()
  local opts = { noremap = true, silent = true }
  for _,value in pairs(local_map.LOCAL_KEYS) do
    if type(value[3]) == 'function' then
      vim.api.nvim_set_keymap( value[1], value[2], _lua_fn(value[3]), opts)
    else
      vim.api.nvim_set_keymap( value[1], value[2], value[3], opts)
    end
  end
end

-- Setup lsp keybindings
M.on_lsp_attach = function(bufnr)
  -- diagnostic
  for _,value in pairs(local_map.LSP_KEY.diagnostic) do
    vim.api.nvim_buf_set_keymap(
      bufnr, 'n', value[1],
      ':lua vim.diagnostic.' .. value[2] .. '<CR>',
      value[3]
    )
  end
  -- lsp
  for _,value in pairs(local_map.LSP_KEY.lsp) do
    vim.api.nvim_buf_set_keymap(
      bufnr, 'n', value[1],
      ':lua vim.lsp.'.. value[2] ..'<CR>',
      value[3]
    )
  end
end

return M
