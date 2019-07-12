" powerline.vim
scriptencoding utf8

let linebars#powerline#_ = {}
let s:_ = linebars#powerline#_

function! s:_.New()
  echo 'you may press'
endfunction

" let status_component = {
"   \ 'active_left' : [
"   \   'buffer_name',
"   \   'status_mode',
"   \   'git_branch'
"   \  ],
"   \
"   \ 'active_right' : [
"   \   'filetype',
"   \   'script_encoding',
"   \   'col_number',
"   \   'total_lines'
"   \  ],
"   \
"   \ 'inactive_left' : [
"   \   'test'
"   \  ],
"   \
"   \ 'inactive_right' : [
"   \   'test'
"   \  ],
" \}
"
"
" function! MyStatusLine(state)
"   let s = ''
"   let g:separator = '%1* : %0*'
"   if a:state ==# 'active'
"     let s .= '%4* %n %0*' " Buffer number.
"     let s .= '%2* %t' " File name
"     let s .= g:separator
"     let s .= '%<' " will truncate here.
"     let s .= '%2* %0*'
"     let s .= '%1*'.s:git_branch[:-2] " Current git branch.
"     let s .= '%2* %([%M%R%H]%) %0*' " Buffer flags.
"     let s .= '%=' " =============separator==============
"     let s .= '%1*'.(&ft ==# '' ? 'none' : '%2*%{&ft}').'%0*' " Filetype.
"     let s .= '%1* (%{&enc})%0*' " File encoding.
"     let s .= g:separator
"     let s .= '%2*col%0*%3v' " Column number
"     let s .= g:separator
"     let s .= '%2* %0*%4L ' " total lines.
"   else
"     let s .= '%n' " Buffer number.
"     let s .= g:separator
"     let s .= '%1 %t' " File name
"   endif
"   return s
" endfunction
