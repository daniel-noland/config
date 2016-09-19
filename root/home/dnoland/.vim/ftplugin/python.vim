" augroup DispatchPython
"    autocmd!
"    autocmd VimEnter,WinEnter,BufWinEnter * if &filetype == 'python' | let b:dispatch = 'python %' | endif
" augroup END

"nnoremap <buffer> <silent><CR><CR> :call PythonRunToggle()<cr>

" Turn off pymode warnings:
" let g:pymode_warnings = 0

" " Override go-to.definition key shortcut to ,d
" let g:pymode_rope_goto_definition_bind = ",d"

" " Override run current python file key shortcut to Ctrl-Shift-e
" let g:pymode_run_bind = ",RUN"

" " Override view python doc key shortcut to Ctrl-Shift-d
" let g:pymode_doc_bind = ",D"

" let g:pymode_rope_rename_bind = '<leader>rr'
" let g:pymode_rope_organize_imports_bind = '<leader>io'
" let g:pymode_rope_autoimport_bind = '<leader>ia'
" let g:pymode_lint_on_write = 1
" let g:pymode_lint_cwindow = 0
" let g:pymode_lint_todo_symbol = 'TD'

" Ultisnips configuration
let g:ultisnips_python_style = 'doxygen'
