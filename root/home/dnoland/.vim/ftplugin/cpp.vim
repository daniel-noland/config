let g:cpp_fold = 1
source ~/.vim/ftplugin/_seperated.vim
" let g:C_UseTool_cmake   = 'yes'
let g:C_UseTool_doxygen = 'yes'
" autocmd FileType g++ let b:dispatch = './out'
let b:UltiSnipsSnippetDirectories = [$HOME . "/.vim/UltiSnips/"]
let g:formatprg_cpp = "astyle"
let g:formatprg_args_expr_cpp = '"--style=google -pcHs".&shiftwidth'
