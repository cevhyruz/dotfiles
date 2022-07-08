local api = vim.api

api.nvim_create_user_command("Note", function()
  require('user.utils').Float()
end, {})
