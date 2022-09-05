local M = {}

function M.format_with_hl(hl_name, icon)
  return string.format("%%#%s# %s", hl_name, icon)
end

return M
