local M = {}

local module_name = 'modules.map_utils'
local fn_store = {}

local function _register_fn(fn)
  table.insert(fn_store, fn)
  return #fn_store
end

function M.lua_fn(fn)
  return string.format(
    '<cmd>lua require("%s").apply_function(%s)<CR>',
    module_name,
    _register_fn(fn)
  )
end

function M.apply_function(id)
  fn_store[id]()
end

function M.setup(options)
  local opts = { noremap = true }
  for _,value in pairs(options) do
    if type(value[3]) == 'function' then
      vim.api.nvim_set_keymap( value[1], value[2], M.lua_fn(value[3]), opts )
    else
      vim.api.nvim_set_keymap( value[1], value[2], value[3], opts)
    end
  end
end


--function M.lua_expr(fn)
  --return string.format(
    --"v:lua.require'%s'.apply_expr(%s)",
    --module_name,
    --_register_fn(fn)
  --)
--end

--function M.apply_expr(id)
  --return vim.api.nvim_replace_termcodes(fn_store[id](), true, true, true)
--end

return M
