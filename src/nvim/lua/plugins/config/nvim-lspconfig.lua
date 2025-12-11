local M = {}
return M

M.specs = {
  config = function()
    local lspconfig = require("lspconfig")

    -- LSP Capabilities for nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    -- Global diagnostics setup
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- show hover on cursor hold
    -- vim.api.nvim_create_autocmd("CursorHold", {
    --   callback = function()
    --     vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
    --   end,
    -- })

    -- Common on_attach function
    local on_attach = function(_, bufnr)
      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float(nil, { border = "rounded" })
      end, opts)
    end

    -- ✅ Lua LSP Setup
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })

    -- ✅ TypeScript LSP Setup (modern)
    local util = require("lspconfig.util")

    lspconfig.ts_ls.setup({
      root_dir = util.root_pattern("tsconfig.base.json", "tsconfig.json", "package.json", ".git", "tsconfig.app.json"),
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- lspconfig.ts_ls.setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })

    -- ✅ Angular LSP Setup (disabled)
    -- lspconfig.angularls.setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })
  end,
}

return M
