local M = {}

local api = vim.api

M.setup = function()

  vim.fn.sign_define( { {
      name = 'DiagnosticSignError',
      text = '',
      texthl = 'DiagnosticSignError',
      numhl = 'DiagnosticLineNrError'
    }, {
      name = 'DiagnosticSignWarn',
      text = '',
      texthl = 'DiagnosticSignWarn',
      numhl = 'DiagnosticLineNrWarn'
    }, {
      name = 'DiagnosticSignHint',
      text = '',
      texthl = 'DiagnosticSignHint',
      numhl = 'DiagnosticLineNrHint'
    }, {
      name = 'DiagnosticSignInfo',
      text = '',
      texthl = 'DiagnosticSignInfo',
      numhl = 'DiagnosticLineNrInfo'
    }
  } )

  local style = { border = 'rounded' }

  vim.diagnostic.config( {
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
  } )

  vim.lsp.handlers['textDocument/hover'] =
      vim.lsp.with( vim.lsp.handlers.hover, { border = style.border } )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
                                                       vim.lsp.handlers
                                                           .signature_help, {
        border = style.border
      } )
end

M.on_attach = function(client, bufnr)
  print( client.name .. ' attached on buffer' )

  api.nvim_create_user_command( 'Format', function()
    vim.lsp.buf.format { async = true }
  end, {} )

  vim.cmd [[
    hi link DiagnosticVirtualTextError LineNr
    hi link DiagnosticVirtualTextWarn  LineNr
    hi link DiagnosticVirtualTextInfo  LineNr
    hi link DiagnosticVirtualTextHint  LineNr

    hi DiagnosticLineNrWarn  guifg=#ff8700 gui=bold " yellow
    hi DiagnosticLineNrInfo  guifg=#5fafff gui=bold " blue
    hi DiagnosticLineNrHint  guifg=#dadada gui=bold " white
    hi DiagnosticLineNrError guifg=#ff5f5f gui=bold " red
  ]]

  -- lsp keys
  require( 'user.maputils' ).setup_lsp_keys( bufnr )

  if client.server_capabilities.documentHighlightProvider then
    api.nvim_create_autocmd("CursorHold", {
      group = api.nvim_create_augroup('lsp_document_highlight', { clear = true }),
      pattern = "*",
      callback = vim.lsp.buf.document_highlight,
    })

    api.nvim_create_autocmd("CursorMoved", {
      group = api.nvim_create_augroup('lsp_document_highlight', { clear = true }),
      pattern = "*",
      callback = vim.lsp.buf.clear_references
    })

    api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = api.nvim_create_augroup('code_action_hint', { clear = true }),
      pattern = "*",
      callback = require('nvim-lightbulb').update_lightbulb
    })
  end
end

M.capabilities = require( 'cmp_nvim_lsp' ).update_capabilities( vim.lsp.protocol
                                                                    .make_client_capabilities() )

return M
