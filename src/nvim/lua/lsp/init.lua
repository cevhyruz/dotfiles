local lb = require "nvim-lightbulb"
local lspinstaller = require "nvim-lsp-installer"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local lspconfig = require "lspconfig"

local function set_formatter(client)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_user_command('Format', function()
      vim.lsp.buf.format { async = true }
    end, {})
  end
end

local function on_attach(client, bufnr)
  set_formatter(client)
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", }, {
    group = vim.api.nvim_create_augroup('lightbulb_codeaction_sign', { clear = true }),
    callback = lb.update_lightbulb
  })
end

local capability_overrides = {
  snippetSupport = true
}

local capabilities = cmp_nvim_lsp.update_capabilities(
  vim.lsp.protocol.make_client_capabilities(),
  capability_overrides)

for _,server in ipairs(lspinstaller.get_installed_servers()) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilites,
    flags = {
      debounce_text_changes = 150
    }
  }
  local ok,config = pcall(require, "lsp.config." .. server.name)
  if not ok then
    config = {}
  end
  lspconfig[server.name].setup(vim.tbl_deep_extend("force", config, opts))
end
