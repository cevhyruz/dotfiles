local a = vim.api

local lb = require "nvim-lightbulb"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local lspconfig = require "lspconfig"
local lspinstaller = require "nvim-lsp-installer"

local key_opts = { noremap = true }
local style = { border = 'rounded' }
local M = {}

lspinstaller.setup {}

local function set_LspReference_highlight()
  vim.cmd [[
    hi LspReferenceText  guibg=red    guifg=yellow gui=underline
    hi LspReferenceRead  guibg=green  guifg=red    gui=underline
    hi LspReferenceWrite guibg=yellow guifg=black  gui=underline
  ]]
end

local function set_diagnostic_keymaps(bufnr, conf)
  for lhs, keymap in pairs(conf or {
    [ '<leader>f' ] = { mode = 'n', rhs = 'open_float()', key_opts},
           [ '[d' ] = { mode = 'n', rhs = 'goto_prev()',  key_opts},
           [ ']d' ] = { mode = 'n', rhs = 'goto_next()',  key_opts},
    [ '<leader>q' ] = { mode = 'n', rhs = 'setloclist()', key_opts},
  }) do
    local rhs = string.format('<cmd>lua vim.diagnostic.%s<CR>', keymap.rhs)
    a.nvim_buf_set_keymap( bufnr, keymap.mode, lhs, rhs, key_opts)
  end

  for lhs, keymap in pairs(conf or {
             ['gd'] = { mode = 'n', rhs = 'definition()',         key_opts },
             ['gD'] = { mode = 'n', rhs = 'declaration()',        key_opts },
             ['gi'] = { mode = 'n', rhs = 'implementation()',     key_opts },
      ['<leader>3'] = { mode = 'n', rhs = 'document_highlight()', key_opts },
              ['K'] = { mode = 'n', rhs = 'hover()',              key_opts },
          ['<C-k>'] = { mode = 'n', rhs = 'signature_help()',     key_opts },
     ['<Leader>rn'] = { mode = 'n', rhs = 'rename()',             key_opts },
             ['gr'] = { mode = 'n', rhs = 'references()',         key_opts },
     ['<Leader>ca'] = { mode = 'n', rhs = 'code_action()',        key_opts }
  }) do
      local rhs = string.format('<cmd>lua vim.lsp.buf.%s<CR>', keymap.rhs)
      a.nvim_buf_set_keymap( bufnr, keymap.mode, lhs, rhs, key_opts)
  end
end

local function set_diagnostic_config()
  vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = style.border,
      source = 'always',
      header = '',
      prefix = ''
    }
  })

  vim.fn.sign_define({
    { name = 'DiagnosticSignError',
      text = '',
      texthl = 'DiagnosticSignError',
      numhl = 'DiagnosticLineNrError'
    },
    { name = 'DiagnosticSignWarn',
      text = '',
      texthl = 'DiagnosticSignWarn',
      numhl = 'DiagnosticLineNrWarn'
    },
    { name = 'DiagnosticSignHint',
      text = '',
      texthl = 'DiagnosticSignHint',
      numhl = 'DiagnosticLineNrHint'
    },
    { name = 'DiagnosticSignInfo',
      text = '',
      texthl = 'DiagnosticSignInfo',
      numhl = 'DiagnosticLineNrInfo'
    }
  })
end

local function on_attach(client, bufnr)

  if client.server_capabilities.documentHighlightProvider then
    a.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = vim.api.nvim_create_augroup('lsp_documentHighlight', {}),
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight
    })
    a.nvim_create_autocmd({ "CursorMoved" }, {
      group = vim.api.nvim_create_augroup('lsp_documentHighlight', {}),
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references
    })
  end
  if client.server_capabilities.codeActionProvider then
    a.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = lb.update_lightbulb
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
      vim.lsp.handlers.signature_help,
      { border = style.border })
   vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = style.border })
end

local function setup()

  a.nvim_create_autocmd({ 'LspAttach' }, {
    callback = function(args)
      set_diagnostic_keymaps(args.buf)
      set_LspReference_highlight()
      set_diagnostic_config()
      update_handler()
    end
  })
  local capabilities = cmp_nvim_lsp.update_capabilities(
    vim.lsp.protocol.make_client_capabilities(),
    { snippetSupport = true })
  for _,server in ipairs(lspinstaller.get_installed_servers()) do
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150
      },
    }
    -- load custom settings if any.
    local ok,config = pcall(require, "lsp.config." .. server.name)
    if not ok then config = {} end
    lspconfig[server.name].setup(vim.tbl_deep_extend("force", config, opts))
  end
end

return setup()
