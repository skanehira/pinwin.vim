" pinwin
" Author: skanehira
" License: MIT

let s:PINWIN_WIDTH = 'pinwin_width'
let s:PINWIN_HEIGHT = 'pinwin_height'

function s:resize() abort
  let tabnr = tabpagenr()
  let windows = gettabinfo(tabnr)[0]['windows']

  let old_winid = win_getid()

  for winid in windows
    let width = gettabwinvar(tabnr, winid, s:PINWIN_WIDTH)
    let height = gettabwinvar(tabnr, winid, s:PINWIN_HEIGHT)

    if width !=# ''
      call win_gotoid(winid)
      let cur_winnr = winnr()
      exe 'vertical resize' .. width
    endif

    if height !=# ''
      call win_gotoid(winid)
      let cur_winnr = winnr()
      if winnr('k') != cur_winnr || winnr('j') != cur_winnr
        exe 'resize' .. height
      endif
    endif

  endfor

  call win_gotoid(old_winid)
endfunction

" @direction
"   width
"   height
function! pinwin#pin(bang, direction) abort
  let tabnr = tabpagenr()
  " do nothing if only 1 window
  let windows = gettabinfo(tabnr)[0]['windows']
  if len(windows) ==# 1
    return
  endif

  if a:bang ==# '!'
    if has_key(w:, s:PINWIN_WIDTH) && a:direction ==# 'width'
      call remove(w:, s:PINWIN_WIDTH)
    endif
    if has_key(w:, s:PINWIN_HEIGHT) && a:direction ==# 'height'
      call remove(w:, s:PINWIN_HEIGHT)
    endif
    return
  endif

  if a:direction ==# 'width'
    let w:pinwin_width = winwidth(0)
  endif
  if a:direction ==# 'height'
    let w:pinwin_height = winheight(0)
  endif

  augroup winpin_resize
    au!
    au WinScrolled * call <SID>resize()
  augroup END
endfunction
