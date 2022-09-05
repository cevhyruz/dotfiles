local a = vim.api

local lb = require "nvim-lightbulb"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local lspconfig = require "lspconfig"
local lspinstaller = require "nvim-lsp-installer"

require("lsp.config.null-ls")

lspinstaller.setup {}

local function set_LspReference_highlight()
  local hi_group = {
    LspReferenceText  = { guibg = "red",    guifg = "yellow", gui = "undercurl" },
    LspReferenceRead  = { guibg = "green",  guifg = "red",    gui = "undercurl" },
    LspReferenceWrite = { guibg = "yellow", guifg = "black",  gui = "undercurl" }
  }
  for name, color in pairs(hi_group) do
    vim.api.nvim_set_hl(0, name, {
      bg = color.guibg,
      fg = color.guifg,
    })
  end
end

local function set_diagnostics()
  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    signs = true,
    severity_sort = true,
    float = {
      focusable = true,
      border = "rounded",
      source = 'always',
      header = "Dagnostic",
      prefix = ''
    }
  })

  for type, icon in pairs({
    Error = "", Warn = "", Hint = "?", Info = ""
  }) do
    local hl = "DiagnosticSign" .. type
    local numhl = "DiagnosticSignLineNr" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = numhl })
  end
end

local function on_attach(client, bufnr)
  -- aerial.on_attach(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    a.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = a.nvim_create_augroup('lsp_documentHighlight', {}),
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight
    })
    a.nvim_create_autocmd({ "CursorMoved" }, {
      group = a.nvim_create_augroup('lsp_documentHighlight', {}),
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references
    })
  end
  if client.server_capabilities.documentFormattingProvider then
    a.nvim_create_user_command('Format', function()
      vim.lsp.buf.format { async = true }
    end, {})
  end
end

local function update_handler()
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { border = "rounded" })
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = "rounded" })
end

local function setup()
  a.nvim_create_autocmd({ "CursorHold", "CursorHoldI", }, {
    group = a.nvim_create_augroup('lightbulb_codeaction_sign', {}),
    pattern = "*",
    callback = lb.update_lightbulb
  })

  a.nvim_create_autocmd({ 'LspAttach' }, {
    callback = function(args)
      -- maputils.set_keymaps(lsp_mappings, { buffer = args.buf })
      set_LspReference_highlight()
      set_diagnostics()
      update_handler()
    end
  })

  local capabilities = cmp_nvim_lsp.update_capabilities(
    vim.lsp.protocol.make_client_capabilities(),
    { snippetSupport = true })
  lspinstaller.setup({ ensure_installed = {} })
  for _, server in ipairs(lspinstaller.get_installed_servers()) do
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150
      },
    }
    local ok, config = pcall(require, "lsp.config." .. server.name);
    if not ok then config = {} end
    lspconfig[server.name]
        .setup(vim.tbl_deep_extend("force", config, opts))
  end
end

return setup()
