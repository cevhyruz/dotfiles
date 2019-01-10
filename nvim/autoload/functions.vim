function! functions#myFoldText()
  " TODO: Make rhs more accurate by determining
  " if first character is a comment sign or not.
  let fold = "  ".getline(v:foldstart)[1:-5]."..."
  let rhs = (v:foldend - v:foldstart) . " lines " . v:folddashes
  " responsive rhs position
  if winwidth(".") < 86
    let spacer = repeat(" ", (winwidth(".") - len(fold) - len(rhs) - 5))
  else
    let spacer = repeat(" ",(86 - len(fold) - len(rhs) - 5))
  endif
  return fold . spacer . rhs
endfunction

