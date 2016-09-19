let g:spFiletype = ""
let g:SPin = ""
let g:SPout = ""
let g:scratchpadDropTo = "out"

function! scratchpad#Open(ft)
  call scratchpad#InOpen(a:ft)
  call scratchpad#OutOpen()
  execute "drop " . g:SPin
endfunction

function! scratchpad#InOpen(ft) 
  let g:spFiletype = a:ft
  if a:ft ==? 'python'
     let l:suffix = 'py'
  elseif a:ft ==? 'perl'
     let l:suffix = 'pl'
  elseif a:ft ==? 'bash'
     let l:suffix = 'sh'
  elseif a:ft ==? 'zsh'
     let l:suffix = 'sh'
  else
     let l:suffix = a:ft
  endif

  let g:SPin = g:scratchpadTmpDir . "__scratch__." . l:suffix
  let g:SPout = g:scratchpadTmpDir . "[__scratch__]." . a:ft . ".out"
  if scratchpad#InIsOpen() == 0
     execute "botright 10 new " . g:SPin
     setlocal bufhidden=wipe nobuflisted noswapfile nowrap
  endif
endfunction

function! scratchpad#OutOpen()
  if scratchpad#OutIsOpen() == 0
     execute "rightbelow vnew " . g:SPout
     setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile nowrap
  endif
endfunction

function! scratchpad#InIsOpen() 
  if bufwinnr(g:SPin) >= 0
     return 1
  else
     return 0
  endif
endfunction

function! scratchpad#OutIsOpen() 
  if bufwinnr(g:SPout) >= 0
     return 1
  else
     return 0
  endif
endfunction

function! scratchpad#IsOpen()
   if scratchpad#InIsOpen() == 1 && scratchpad#OutIsOpen() == 1
      return 1
   else
      return 0
   endif
endfunction

function! scratchpad#Run()
  call scratchpad#Open(g:spFiletype)
  execute "drop " . g:SPin
  silent write
  execute "silent !chmod +x " . g:SPin
  let l:view = winsaveview()
  execute "drop " . g:SPout
  setlocal modifiable
  let l:regw = @w
  %delete w
  let @w = l:regw
  let l:out = system(g:SPin)
  let @w = l:out
  normal! gg"wP
  let @w = l:regw
  "call append(line('0'), l:out)
  setlocal nomodifiable
  if g:scratchPadDropTo == "in"
     execute "drop " . g:SPin
     call winrestview(l:view)
  endif
  redraw!
endfunction

function! scratchpad#GetFileName()
   let g:SPin = @%
endfunction

function! scratchpad#UpdatePadData()
   call scratchpad#GetFileName()
endfunction
