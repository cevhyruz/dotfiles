local M = {}

local function lsp_highlight_document(client)
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

local function lsp_keymaps(bufnr)
local buf_keymap = vim.api.nvim_buf_set_keymap

-- lsp
  nkeymap('gd', ':lua vim.lsp.buf.definition()<cr>')
  nkeymap('gD', ':lua vim.lsp.buf.declaration()<cr>')
  nkeymap('gi', ':lua vim.lsp.buf.implementation()<cr>')
  nkeymap('gw', ':lua vim.lsp.buf.document_symbol()<cr>')
  nkeymap('gw', ':lua vim.lsp.buf.workspace_symbol()<cr>')
  nkeymap('gr', ':lua vim.lsp.buf.references()<cr>')
  nkeymap('gt', ':lua vim.lsp.buf.type_definition()<cr>')
  nkeymap('K', ':lua vim.lsp.buf.hover()<cr>')
  nkeymap('<c-k>', ':lua vim.lsp.buf.signature_help()<cr>')
  nkeymap('<leader>af', ':lua vim.lsp.buf.code_action()<cr>')
  nkeymap('<leader>rn', ':lua vim.lsp.buf.rename()<cr>')


  local opts = { noremap = true }
  buf_keymap(bufnr, 'n', 'gd', "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_keymap(bufnr, 'n', 'gD', ":lua vim.lsp.buf.declaration()<CR>", opts)
  buf_keymap(bufnr, "n", 'gi', "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

  buf_keymap(bufnr, "n", 'K', "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_keymap(bufnr, "n", '<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  buf_keymap(
    bufnr,
    "n",
    "gl",
    '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>',
    opts
  )
  buf_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  buf_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = ""  },
    { name = "DiagnosticSignHint", text = ""  },
    { name = "DiagnosticSignInfo", text = ""  }
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
      prefix = ''
    }
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

M.on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
  end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

return M
