local handlers = require('lsp.handlers')

require('nvim-lsp-installer').on_server_ready(function(server)
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
    flags = {
      debounce_text_changes = 150
    }
  }

  local ok, lsp_config = pcall( require, 'lsp.config' .. '.' .. server.name )
  if not ok then
    lsp_config = {}
    print(server.name .. ' not found in lsp/config. Setting up defaults.')
  end

  server:setup( vim.tbl_deep_extend( 'force', lsp_config, opts ) )
end)
