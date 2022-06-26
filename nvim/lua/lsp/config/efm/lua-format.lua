return {
  formatCommand = 'lua-format -i '
    .. '--double-quote-to-single-quote '
    .. '--indent-width=2 '
    .. '--align-parameter '
    .. '--align-table-field '
    .. '--spaces-inside-functioncall-parens '
    .. '--spaces-inside-table-braces '
    .. '--keep-simple-function-one-line',
  formatStdin = true
}
