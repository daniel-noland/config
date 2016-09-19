function! Underline(chars)
  let chars = empty(a:chars) ? '-' : a:chars
  let nr_columns = virtcol('$') - 1
  let uline = repeat(chars, (nr_columns / len(chars)) + 1)
  put =strpart(uline, 0, nr_columns)
endfunction
command! -nargs=? Underline call Underline(<q-args>)
nnoremap <buffer><leader><leader>h1 :call Underline("=")<CR>
nnoremap <buffer><leader><leader>h2 :call Underline("-")<CR>
nnoremap <buffer><leader><leader>h3 0i###<esc>A###<esc>
nnoremap <buffer><leader><leader>h4 0i####<esc>A####<esc>
nnoremap <buffer><leader><leader>h5 0i#####<esc>A#####<esc>
nnoremap <buffer><leader><leader>h6 0i######<esc>A######<esc>
nnoremap <buffer><leader><leader>h7 0i#######<esc>A########<esc>
nnoremap <buffer><leader><leader>h8 0i########<esc>A#########<esc>
nnoremap <buffer><leader><leader>h9 0i#########<esc>A##########<esc>

nnoremap <buffer><leader><leader># 0i#<esc>A#<esc>0

inoremap <buffer><silent><Bar>   <Bar><Esc>:call MdAlign()<CR>a
nnoremap <buffer><silent><leader><Bar> :call MdAlign()<CR>

function! MdAlign()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
