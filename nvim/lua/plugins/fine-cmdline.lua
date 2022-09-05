local fineline = require('fine-cmdline')
local fn = fineline.fn

-- vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})

fineline.setup({
  cmdline = {
    -- Prompt can influence the completion engine.
    -- Change it to something that works for you
    prompt = ': ',
    -- Let the user handle the keybindings
    enable_keymaps = false
  },
  popup = {
    buf_options = {
      -- Setup a special file type if you need to
      filetype = 'FineCmdlinePrompt'
    },
    position = {
      row = '5%',
      col = '1%',
    },
  },
  hooks = {
    set_keymaps = function(imap, feedkeys)
      -- Restore default keybindings...
      -- Except for `<Tab>`, that's what everyone uses to autocomplete
      imap('<Esc>', fn.close)
      imap('<C-c>', fn.close)
      imap('K', fn.up_search_history)
      imap('J', fn.down_search_history)
    end
  }
})
