local status_ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not status_ok then
  return
end

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require('lsp.handlers').on_attach,
    capabilities = require('lsp.handlers').capabilities
  }

  if server.name == 'sumneko_lua' then
    local sumneko_opts = require('lsp.config'.. '.' .. server.name)
    opts = vim.tbl_deep_extend('force', sumneko_opts, opts)
  end

  -- This setup() function is exactly the same as the lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)
