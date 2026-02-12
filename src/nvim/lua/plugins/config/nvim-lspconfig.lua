-- For a complete list of LSP's see
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

local M = {}

M.specs = {
  config = function()

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Diagnostics UI
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- on_attach
    local on_attach = function(_, bufnr)
      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float(nil, { border = "rounded" })
      end, opts)
    end

    ------------------------------------------------------------------
    -- ✅ Lua LSP
    ------------------------------------------------------------------
    vim.lsp.config("lua_ls", {
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

    vim.lsp.enable("lua_ls")

    ------------------------------------------------------------------
    -- ✅ TypeScript LSP
    ------------------------------------------------------------------
    vim.lsp.config("ts_ls", {
      root_markers = {
        "tsconfig.base.json",
        "tsconfig.json",
        "tsconfig.app.json",
        "package.json",
        ".git",
      },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.enable("ts_ls")

    -- Emmet
    vim.lsp.enable("emmet_ls")

  end,
}

return M
