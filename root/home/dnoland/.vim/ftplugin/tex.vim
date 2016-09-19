"Vim LaTeX suite commands
let g:Tex_CompileRule_pdf = '~/.bin/stex.sh $*'
let g:Tex_GotoError = 0
TTarget pdf
map <F8> :w<cr>\ll
imap <F8> <esc>:w<cr>\ll
