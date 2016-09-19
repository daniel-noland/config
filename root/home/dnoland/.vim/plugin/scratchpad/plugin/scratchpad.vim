augroup scratchPad
   autocmd!
   execute "autocmd BufEnter " . g:scratchpadTmpDir . "__scratch__.* silent call scratchpad#UpdatePadData()"
   execute "autocmd BufEnter " . g:scratchpadTmpDir . "__scratch__.* silent nnoremap <buffer> <leader><cr> :call scratchpad#Run()<CR>"
augroup END
