nohlsearch
function! s:node()
   silent let @/='*'
   silent set nohlsearch
endfunction
nmap <silent><buffer>j :call <SID>node()<CR>n<CR>
nmap <silent><buffer>k :call <SID>node()<CR>N<CR>
