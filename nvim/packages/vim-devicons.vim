
" Enable folder/directory glyph flag.
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" enable pattern matching glyphs on folder/directory (enabled by default with 1)
let g:DevIconsEnableFolderPatternMatching = 1

" change the default dictionary mappings for file extension matches
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js'] = 'ƛ'


" TODO: optimize this.
" change the default dictionary mappings for exact file node matches
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'bash.bashrc' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'fzf' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'inputrc' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'profile' ] = ''

let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'aliases' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'colors' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'exports' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'functions' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'options' ] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols[ 'prompt' ] = ''

" add or override individual additional filetypes
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['myext'] = 'ƛ'

" Prettify Icons. {{{
let g:palette = {
    \'base03': 8,
    \'base02': 0,
    \'base01': 251,
    \'base00': 11,
    \'base0': 12,
    \'base1': 14,
    \'base2': 7,
    \'base3': 15,
    \'yellow': 3,
    \'orange': 130,
    \'red': 1,
    \'magenta': 5,
    \'violet': 13,
    \'blue': 4,
    \'cyan': 6,
    \'green': 2
\}

let g:icons = {
    \ 'normal':    [ '' ],
    \ 'emphasize': [ '' ],
    \ 'green':     [ '' ],
    \ 'blue':      [ '', '', ''],
    \ 'yellow':    [ '', '', ''],
    \ 'magenta':   [ '' ],
    \ 'orange':    [ '' ],
    \ 'red':       [ '' ],
    \ 'violet':    [ '' ],
    \ 'cyan':      [ '', '' ]
\}

function! PrettyIcon(config)
  let colors = keys(a:config)

" TODO: Add support for light background
" and maybe support for icon background colors too??
  augroup devicons_colors

    autocmd!
    for color in colors
      if color == 'normal'
        exec 'autocmd FileType nerdtree' .
          \ 'highlight devicons_' . color .
            \ ' ctermfg=' . g:palette.base01
      elseif color == 'emphasize'
        exec 'autocmd FileType nerdtree' .
          \ 'highlight devicons_' . color .
            \ ' ctermfg=' . g:palette.base1
      else
        exec 'autocmd FileType nerdtree highlight devicons_' . color .
          \ ' ctermfg='. g:palette[color]
      endif

      exec 'autocmd FileType nerdtree syntax match devicons_' . color .
        \ ' /\v' . join(a:config[color], '|') . '/ containedin=ALL'

    endfor
  augroup END
endfunction

" }}}

" Pretty file. {{{
function! PrettyFile(filename, cterm, fg)
  exec 'autocmd filetype nerdtree highlight ' .
    \ a:filename .
    \ ' cterm='. a:cterm .
    \ ' ctermfg='. a:fg

  exec 'autocmd filetype nerdtree syn match ' .
    \ a:filename . ' #^\s\+.*'. a:filename .'$#'
endfunction
" }}}

call PrettyIcon(g:icons)
call PrettyFile('gitignore', 'none', 'green')