function! functions#myFoldText()
  " TODO: Make rhs more accurate by determining
  " if first character is a comment sign or not.
  let fold = "  ".getline(v:foldstart)[1:-5]." ..."
  let rhs = (v:foldend - v:foldstart) . " lines " . v:folddashes
  " responsive rhs position
  if winwidth(".") < 86
    let spacer = repeat(" ", (winwidth(".") - len(fold) - len(rhs) - 5))
  else
    let spacer = repeat(" ",(86 - len(fold) - len(rhs) - 5))
  endif
  return fold . spacer . rhs
endfunction

function! functions#dimInactiveWindows()
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let l:range = ""
    if i != winnr()
      if &wrap
        " HACK: when wrapping lines is enabled, we use the maximum number
        " of columns getting highlighted. This might get calculated by
        " looking for the longest visible line and using a multiple of
        " winwidth().
        let l:width=256 " max
      else
        let l:width=winwidth(i)
      endif
      let l:range = join(range(1, l:width), ',')
    endif
    call setwinvar(i, '&colorcolumn', l:range)
  endfor
endfunction
