local function toggle()
  if vim.go.hls then
    print('   hlsearch')
    vim.go.hls = false
    vim.cmd [[ HlSearchLensDisable ]]
  else
    print('   hlsearch')
    vim.go.hls = true
    vim.cmd [[ HlSearchLensEnable ]]
  end
end

return toggle
