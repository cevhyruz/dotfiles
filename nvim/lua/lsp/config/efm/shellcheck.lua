return {
  lintCommand = 'shellcheck --format=gcc -x -',
  lintStdin = true,
  lintFormats = {
        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'
    },
  formatCommand = 'shfmt -ci -bn -s -i ' .. vim.bo.shiftwidth,
  formatStdin = true
}
