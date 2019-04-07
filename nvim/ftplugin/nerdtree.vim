augroup NERDTreeSetup
    autocmd!
    autocmd VimEnter * call NERDTreeAddKeyMap({'key': '<F2>', 'scope': 'all', 'callback': 'NERDTreeDeleteNode'}) |
                     \ call NERDTreeAddKeyMap({'key': '<F3>', 'scope': 'all', 'callback': 'NERDTreeAddNode'}) |
                     \ call NERDTreeAddKeyMap({'key': '<F4>', 'scope': 'all', 'callback': 'NERDTreeMoveNode'})
augroup END
