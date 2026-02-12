local M = {}

M.specs = {
  dependencies = {
   "rafamadriz/friendly-snippets",
   "mattn/emmet-vim",
  }
  config = function()
    local luasnip = require("luasnip")
    -- Load friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Optional LuaSnip config
    luasnip.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
    })

    -- Snippet Jump Keymaps
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        return "<Tab>"
      end
    end, { expr = true, silent = true })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        return "<S-Tab>"
      end
    end, { expr = true, silent = true })
  end,
}

return M
