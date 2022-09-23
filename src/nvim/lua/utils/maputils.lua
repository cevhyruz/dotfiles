local M = {}

local lsp_keys = {}

local function on_attach()
  vim.api.nvim_create_autocmd({ 'LspAttach' }, {
   callback = function(args)
     M.set_keymap(lsp_keys, { buffer = args.buf })
  end
  })
end

function M.set_keymap(mappings, opts)
  for _,value in pairs(mappings) do
    local options = {
      noremap = true,
      silent = true
    }
    -- remove desc and add opts
    if value[4] ~= nil then
      if value[4].desc == "on_attach" then
        table.insert( lsp_keys, { value[1], value[2], value[3],
          vim.tbl_deep_extend("force", options, opts or {} ) })
        goto continue
      end
    end
    -- cmd mapping should not be silenced.
    if value[1] == "c" then
      options = vim.tbl_deep_extend("force", options, { silent = false })
    end
    vim.keymap.set( value[1], value[2], value[3],
      vim.tbl_deep_extend("force", options, value[4] or {}) )
    ::continue::
  end
--   on_attach()
end


return M
