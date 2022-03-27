local M = {}

local module_name = 'modules/map_utils'
local fn_store = {}

local function _register_fn(fn)
  table.insert(fn_store, fn)
  return #fn_store
end

M.keymap = function(mode, lhs, rhs, opts )
  local opts = { noremap = true }
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

M.lua_fn = function(fn)
  return string.format(
    "<cmd>lua require('%s').apply_function(%s)<CR>",
    module_name,
    _register_fn(fn)
  )
end

M.apply_function = function(id)
  fn_store[id]()
end

M.lua_expr = function(fn)
  return string.format(
    "v:lua.require'%s'.apply_expr(%s)",
    module_name,
    _register_fn(fn)
  )
end

M.apply_expr = function(id)
  return vim.api.nvim_replace_termcodes(fn_store[id](), true, true, true)
end

return M
