require('cevhyruz.options')
require('cevhyruz.packages')
require('cevhyruz.keybindings')
require('cevhyruz.abbrev')

require('nvim-lsp-installer').on_server_ready(function(server)
  local options = {}
  if server.name == 'sumneko_lua' then
    options = require('lsp_server' .. '.' .. server.name)
  end
  server:setup(options)
end)

-- Setup lspconfig.
require('lspconfig')['sumneko_lua'].setup {
  capabilities = require('cmp_nvim_lsp')
    .update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

-- @TODO: require localrc
