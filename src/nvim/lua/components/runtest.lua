local function runtest()
  local shebang = vim.inspect( vim.api.nvim_buf_get_lines(0, 0, 1, false))
  if vim.fn.expand('%:e') or shebang  ~= '(bash|sh)' then
    vim.api.nvim_command(string.format('!test/run %s', vim.fn.expand('%:t')))
  end
end

return runtest
