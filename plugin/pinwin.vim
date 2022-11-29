" pinwin
" Author: skanehira
" License: MIT

if exists('loaded_pinwin')
  finish
endif
let g:loaded_pinwin = 1

command! -bang -nargs=1 Pinwin call pinwin#pin('<bang>', <f-args>)
