local M = {}

function M.setup()
  local signs = {
    { name = 'DiagnosticSignError', text = "" },
    { name = 'DiagnosticSignWarn',  text = "" },
    { name = 'DiagnosticSignHint',  text = "" },
    { name = 'DiagnosticSignInfo',  text = "" }
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name,
      {
        texthl = sign.name,
        text = sign.text,
        numhl = ''
      }
    )
  end

  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      active = signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '' }
  })

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = 'rounded'
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = 'rounded'
  })
end

function M.on_attach(client, bufnr)
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
  end

  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

  local mappings = {
    -- Diagnostic. See ':help vim.diagnostic.*'
    diagnostic = {
      { '<leader>f', 'open_float()' },
      { '[d',        'goto_prev()'  },
      { ']d',        'goto_next()'  },
      { '<leader>q', 'setloclist()' },
    },
    -- LSP. see ':help vim.lsp.*'
    lsp = {
      { 'gd',         'buf.definition()'                   },
      { 'gD',         'buf.declaration()'                  },
      { 'gi',         'buf.implementation()'               },
      { 'K',          'buf.hover()'                        },
      { '<C-k>',      'buf.signature_help()'               },
      { '<leader>rn', 'buf.rename()'                       },
      { 'gr',         'buf.references()'                   },
      { '<leader>ca', 'buf.code_action()'                  },
      { 'gl',         'diagnostic.show_line_diagnostics()' },
    }
  }

  local map = vim.api.nvim_buf_set_keymap
  for _,value in pairs(mappings.diagnostic) do
    map(
      bufnr, 'n', value[1],
      '<cmd>'..'lua vim.diagnostic.'..value[2]..'<CR>',
      { noremap = true }
    )
  end

  for _,value in pairs(mappings.lsp) do
    map(
      bufnr, 'n', value[1],
      '<cmd>'..'lua vim.lsp.'..value[2]..'<CR>',
      { noremap = true }
    )
  end

  -- lsp highlighted document
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup end
      ]],
      false
    )
  end
end

M.capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

return M
