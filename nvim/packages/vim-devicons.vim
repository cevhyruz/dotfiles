let g:WebDevIconsUnicodeDecorateFolderNodes = 0
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderPatternMatching = 0
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''

let g:ShellGlyph =''
let g:TmuxGlyph = ''
let g:licenseGlyph = ''
let g:snippetGlyph = ''

let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {
  \ 'keybindings.conf' : g:TmuxGlyph,
  \       'theme.conf' : g:TmuxGlyph,
  \          'license' : g:licenseGlyph,
  \      'bash.bashrc' : g:ShellGlyph,
  \     'local.bashrc' : g:ShellGlyph,
  \              'fzf' : g:ShellGlyph,
  \          'inputrc' : g:ShellGlyph,
  \          'profile' : g:ShellGlyph,
  \          'aliases' : g:ShellGlyph,
  \           'colors' : g:ShellGlyph,
  \          'exports' : g:ShellGlyph,
  \        'functions' : g:ShellGlyph,
  \          'options' : g:ShellGlyph,
  \           'prompt' : g:ShellGlyph,
  \        'tmux.conf' : g:TmuxGlyph
\}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {
  \ 'otf': '',
  \ 'snippets': g:snippetGlyph
\}
let g:palette = {
  \  'base03' : 8,
  \  'base02' : 0,
  \  'base01' : 251,
  \  'base00' : 11,
  \   'base0' : 12,
  \   'base1' : 14,
  \   'base2' : 7,
  \   'base3' : 15,
  \  'yellow' : 3,
  \  'orange' : 130,
  \     'red' : 1,
  \ 'magenta' : 5,
  \  'violet' : 13,
  \    'blue' : 4,
  \    'cyan' : 6,
  \   'green' : 2
\}
let g:icons = {
  \ 'emphasize' : [ '' ],
  \    'normal' : [ '' ],
  \     'green' : [ '' ],
  \      'blue' : [ '', '', '' ],
  \    'yellow' : [ '', '', '','' ],
  \   'magenta' : [ '' ],
  \    'orange' : [ '', '' ],
  \       'red' : [ '' ],
  \    'violet' : [ '' ],
  \      'cyan' : [ '', '' ]
\}

function! PrettyNerdTree(config)
  let colors = keys(a:config)
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

call PrettyNerdTree(g:icons)
