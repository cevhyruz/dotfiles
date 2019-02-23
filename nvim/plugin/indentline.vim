nnoremap <leader>i<space> :IndentLinesToggle <cr>

let g:indentLine_char                 = '┆'
let g:indentLine_first_char           = '┆' "┃
let g:indentLine_color_term           = 240
let g:indentLine_bgcolor_term         = 234 "TODO: toggle this in dim_inactive_window
let g:indentLine_indentLevel          = 14
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileType             = ['vim', 'sh']
let g:indentLine_fileTypeExclude      = []
let g:indentLine_bufTypeExclude       = ['help', 'terminal']
let g:indentLine_bufNameExclude       = ['_.*', 'NERD_tree.*']
