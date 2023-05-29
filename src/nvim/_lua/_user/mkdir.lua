vim.api.nvim_create_user_command("Write", function(path)
  print(vim.fn.mkdir(vim.fn.expand(string.format(path, ":p:h")), "p"))
  -- vim.cmd("write")
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup('mkdir', { clear = true }),
  callback = function()
    vim.fn.mkdir(vim.fn.expand("%:p:h"), "p")
  end
})
