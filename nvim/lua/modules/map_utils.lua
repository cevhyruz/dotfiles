local M = {}

local fn_table = {}
local module_name = 'modules.map_utils'

-- register local function
local function _register_fn(fn)
  table.insert(fn_table, fn)
  return #fn_table
end

-- apply
local function lua_fn(fn)
  return string.format(
    '<cmd>lua require("%s").apply_function(%s)<CR>',
    module_name,
    _register_fn(fn)
  )
end

-- execute registered function
function M.apply_function(id)
  fn_table[id]()
end

-- setup core keybindings including function mappings.
function M.setup(mappings)
  local opts = { noremap = true }
  for _,value in pairs(mappings) do
    if type(value[3]) == 'function' then
      vim.api.nvim_set_keymap( value[1], value[2], lua_fn(value[3]), opts )
    else
      vim.api.nvim_set_keymap( value[1], value[2], value[3], opts)
    end
  end
end

--function M.setup_cmp(cmp)
  --local keys = require('user.keybindings').cmp_keys
  --local new_map = {}
  --for _,value in pairs(keys) do
    --new_map = string.format('[' .. value[1] .. '] = cmp.mapping.' .. value[2])
  --end
  --return new_map
--end

-- Setup lspconfig keybindings
function M.setup_lsp_keys(bufnr)
  local keys = require('user.keybindings').lspconfig_keys
  local buffermap = vim.api.nvim_buf_set_keymap

  for _,value in pairs(keys.diagnostic) do
    buffermap(
      bufnr, 'n', value[1],
      '<cmd>'..'lua vim.diagnostic.'..value[2]..'<CR>',
      { noremap = true }
    )
  end
  for _,value in pairs(keys.lsp) do
    buffermap(
      bufnr, 'n', value[1],
      '<cmd>'..'lua vim.lsp.'..value[2]..'<CR>',
      { noremap = true }
    )
  end
end

return M
