local function toggle()
  if vim.wo.spell then
    vim.opt.spell = false
      -- print('disabled spell')
  else
    vim.opt.spell = true
    vim.opt.spelllang = { 'en_us' }
    -- print('enabled spell')
  end
end

return toggle
