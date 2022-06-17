local M = {}

-- - go-to-definition
-- - find-references
-- - hover
-- - completion
-- - rename
-- - format
-- - refactor

M.setup = function()
  local signs = {
    { name = 'DiagnosticSignError', text = "", hl = 'DiagnosticLineNrError' },
    { name = 'DiagnosticSignWarn',  text = "", hl = 'DiagnosticLineNrWarn'  },
    { name = 'DiagnosticSignHint',  text = "", hl = 'DiagnosticLineNrHint'  },
    { name = 'DiagnosticSignInfo',  text = "", hl = 'DiagnosticLineNrInfo'  }
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define( sign.name, { texthl = sign.name, numhl = sign.hl })
  end

  local style = { border = 'rounded' }

  vim.diagnostic.config({
    virtual_text = true,
    signs = {
      active = signs
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = style.border,
      source = 'always',
      header = '',
      prefix = '' }
  })

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = style.border
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = style.border
  })
end

M.on_attach = function(client, bufnr)
  print(client.name .. ' attached on buffer')

  vim.cmd [[
    command! Format execute 'lua vim.lsp.buf.formatting()'
  ]]

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

  require('user.keybindings').on_lsp_attach(bufnr)

  -- lsp highlighted document
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup end

        augroup code_action_hint
        autocmd! * <buffer>
        autocmd CursorHold,CursorHoldI <buffer> lua require('nvim-lightbulb').update_lightbulb()
        augroup end
      ]],
      false
    )
  end
end

M.capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities())

return M
