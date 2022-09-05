local M = {}

local fn_table = {}

---Store function with id in function table for calling later.
---@param func function the actual function to store.
---@return number same id that was provided.
function M.register_fn(func)
  vim.validate { fn = { func, 'f' }, }
  table.insert(fn_table, func)
  return #fn_table
end

---Get the function with id
---@param id number id of the fn to retrive
---@return function
function M.get_fn(id)
  vim.validate { id = { id, 'n' } }
  return fn_table[id] or function() end
end

-- call stored function keys
function M.call_fn(id, ...)
  return M.get_fn(id)(...)
end

return M
