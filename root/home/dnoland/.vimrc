" vim: ft=vim
" basic settings....
let $PATH .= ':/usr/local/bin:/home/dnoland/.bin/'
set laststatus=2
set encoding=utf-8
set termencoding=utf-8
let g:mapleader = '\'
let g:maplocalleader = ','
" set nocompatible
" colorscheme ir_black
" colorscheme jellybeans
" colorscheme hybrid
colorscheme dan_custom
" colorscheme distinguished_dan
" colorscheme distinguished
set bg=dark
syntax enable
filetype plugin indent on
" set autoindent
set autoread
set noshowmode
set relativenumber
set foldmethod=syntax
set foldcolumn=1
set foldlevel=4
set foldminlines=0
" set ttyfast
set diffopt=filler,context:5,vertical
set clipboard=unnamedplus

" improves regular expressions
set magic
" set noautowrite
set autowrite
set lazyredraw
set linebreak
set shiftround
set noshowcmd
set noerrorbells
set showmatch
set showfulltag
set switchbuf=useopen
" set wrapscan
" set wrapmargin=4
set expandtab
set smarttab
" Don't set this with filetype plugin indent on
" set smartindent
set tabstop=4
set shiftwidth=3
set hlsearch
set incsearch
set history=3000
set list
" set listchars=tab:▸\ ,eol:¬
set listchars=tab:▸\ 
set hidden
set virtualedit=block
set splitbelow
set splitright

" runtime macros/matchit.vim
set wildmenu
set wildmode=longest:full,full
set ignorecase
set smartcase
set title
set scrolloff=5
set sidescrolloff=5
set backupdir=~/.vim-tmp,~/.tmp
set directory=~/.vim-tmp,~/.tmp
set backspace=indent,eol,start
set shortmess=atIWAc
set timeoutlen=444
set ttimeoutlen=10

" current directory is always matching the
" content of the active window
set autochdir

" remember some stuff after quiting vim:
" marks, registers, searches, buffer list
set viminfo='20,<50,s10,h,%

" Return to last edit position when opening files (You want this!)
augroup AfterRead
   autocmd!
   autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
augroup END

func! DeleteTrailingWS()
  let l:view = winsaveview()
  %s/\s\+$//ge
  call winrestview(l:view)
endfunc

" TODO: move these calls functions to ftplugin files
augroup TrailingWhiteSpace
   autocmd!
   autocmd BufWrite *.py :call DeleteTrailingWS()
   autocmd BufWrite *.java :call DeleteTrailingWS()
   autocmd BufWrite *.c :call DeleteTrailingWS()
   autocmd BufWrite *.cpp :call DeleteTrailingWS()
   autocmd BufWrite *.cxx :call DeleteTrailingWS()
   autocmd BufWrite *.h :call DeleteTrailingWS()
   autocmd BufWrite *.hh :call DeleteTrailingWS()
   autocmd BufWrite *.hpp :call DeleteTrailingWS()
   autocmd BufWrite *.hxx :call DeleteTrailingWS()
   autocmd BufWrite *.sh :call DeleteTrailingWS()
   autocmd BufWrite *.bash :call DeleteTrailingWS()
   autocmd BufWrite *.html :call DeleteTrailingWS()
   autocmd BufWrite *.shtml :call DeleteTrailingWS()
   autocmd BufWrite *.js :call DeleteTrailingWS()
   autocmd BufWrite *.latex :call DeleteTrailingWS()
   autocmd BufWrite *.tex :call DeleteTrailingWS()
   autocmd BufWrite *.zsh :call DeleteTrailingWS()
augroup END

" Automatically turn on and off hilighting depending on entering or leaving
" windows
augroup CursorLine 
   autocmd!
   autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
   autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
   autocmd WinLeave * setlocal nocursorline
   autocmd WinLeave * setlocal nocursorcolumn
augroup END

" NERDTree toggle
nnoremap "" :NERDTreeTabsToggle<CR>

" " Coveragepy
" nnoremap <leader>c :Coveragepy session<CR>
" nnoremap <leader>j :Coveragepy show<CR>
" nnoremap <leader>r :Coveragepy refresh<CR>

" Normal mode mappings
noremap J 5<down>
noremap K 5<up>
noremap H 5<left>
noremap L 5<right>
noremap <C-j> 3j3<C-e>
noremap <C-k> 3k3<C-y>
nnoremap <silent><leader>v :vsplit<cr>
nnoremap <silent><leader>h :split<cr>
" noremap <C-l> :bnext<CR>
" noremap <C-h> :bprevious<CR>
" nnoremap <M-t> :tabnew<CR>
" nnoremap <M-,> :tabprevious<CR>
" nnoremap <M-.> :tabnext<CR>

" nnoremap <leader>t :tabnew<space>
nnoremap <leader>p :setlocal paste!<CR>
nnoremap <leader>s :setlocal spell!<CR>
" nnoremap zz z=


" Simple script to toggle relative or abs line numbers
function! NumberToggle()
   if(&relativenumber == 1)
      set norelativenumber
      set number
   else
      set number
      set relativenumber
   endif
   call NumberFix()
endfunc

function! NumberFix()
   if(&buftype=='nofile' || &buftype=='quickfix' || &buftype =='help' )
      set norelativenumber
      set nonumber
   endif
endfunc

" Automatically switch to abs line numbers when focus is lost
augroup LineNumberCorrection
   autocmd!
   autocmd FocusGained,BufEnter,WinEnter,InsertLeave * set number | set relativenumber 
   autocmd FocusLost,BufLeave,WinLeave,InsertEnter * set norelativenumber | set number 
   autocmd FocusLost,FocusGained,BufLeave,BufEnter,WinEnter,WinLeave * call NumberFix()
augroup END

" Automatacally open bookmarks in NERDTree
let g:NERDTreeShowBookmarkd=1

" Fix syntax hilighting on my .shellrc file
" TODO: Use vim ft annotations to obviate this command
augroup SyntaxFix
   autocmd!
   autocmd BufRead,BufNewFile .shellrc setfiletype sh
   autocmd BufRead,BufNewFile .aliasrc setfiletype sh
   autocmd BufRead,BufNewFile .vundlerc setfiletype vim
augroup END

" Rainbow parentheses config
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rpt_loadcmd_toggle = 0

" Function to make a buffer a scratch buffer
function! MakeScratch() 
   setlocal buftype=nofile
   setlocal bufhidden=hide
   setlocal noswapfile
   setlocal readonly
   setlocal nomodifiable
endfunction

function! HistDiff()
   %y
   let my_view = winsaveview()
   let my_ft = &filetype
   let my_file = bufname("%")
   tabnew
   only
   execute "buffer ".my_file
   vnew
   let i = 0
   while buffer_exists("[earlier]:".i) != 0
      let i = i + 1
   endw
   0put
   execute "file [earlier]:".i
   execute "setf " . my_ft
   call MakeScratch()
   call winrestview(my_view)
   diffthis
   wincmd l
   diffthis
   later 999999999999d
   wincmd x
   wincmd h
   diffupdate
   " call SetupDiff()
   " hello
endfunc

" nnoremap <silent><leader>hd :call HistDiff()<CR>

" Turn off search hl
noremap <silent> <leader>, :nohlsearch<cr>

" Fix the "sudo" problem
cmap w!! w !sudo tee % >/dev/null

" " vim-session
" let g:session_default_overwrite = 1
" let g:session_autosave = 'yes'
" let g:session_autosave_periodic = 1
" let g:session_autoload = 'yes'

" CtrlP configuration
" let g:ctrlp_map = '<c-o>'
noremap <M-b> :CtrlPBuffer<CR>
noremap <M-m> :CtrlPMixed<CR>
noremap '' :CtrlPMRU<CR>

" Fugitive mappings:
nnoremap <leader>gs :Gstatus<CR>

" Conventional shifting in visual mode
vnoremap < <gv
vnoremap > >gv

" Tagbar
nnoremap \|\| :TagbarToggle<CR>

" Make searching more sane
nnoremap / /\v
nnoremap ? ?\v
vnoremap / /\v
vnoremap ? ?\v

" Make the size of minimized splits 0
set winminheight=0

" vim commentary 
nnoremap <F8> :TComment<CR>
nnoremap <M-space> :TComment<CR>
vnoremap <F8> :TComment<CR>
vnoremap <M-space> :TComment<CR>

" Set up persist undo
set undofile
set undodir=$HOME/.vim/undo/
set undolevels=3000
set undoreload=3000

" Glowshift config
let g:glowshi_ft_no_default_key_mappings = 1
nmap f <plug>(glowshi-ft-f)
nmap F <plug>(glowshi-ft-F)
nmap t <plug>(glowshi-ft-t)
nmap T <plug>(glowshi-ft-T)
nmap ; <plug>(glowshi-ft-repeat)
vmap f <plug>(glowshi-ft-f)
vmap F <plug>(glowshi-ft-F)
vmap t <plug>(glowshi-ft-t)
vmap T <plug>(glowshi-ft-T)
vmap ; <plug>(glowshi-ft-repeat)

" Fold with space
nnoremap <space> za

" Git gutter configuration
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = ''
let g:gitgutter_sign_removed = '↩'
let g:gitgutter_sign_removed_first_line = '▲'
let g:gitgutter_sign_modified_removed = '⚑'

" EX mode.  Useful sometimes I guess
nnoremap <C-x> q:i

" Thanks tim
if !empty($SUDO_USER) && $USER !=# $SUDO_USER
   set viminfo=
   set directory-=~/tmp
   set backupdir-=~/tmp
   set noundofile
   set undodir=
   set backupskip+=*
endif

let g:local_config_file = "~/.config/nvim/local.vim"
if filereadable(expand(g:local_config_file))
  source g:local_config_file
endif

" Accumulating register
" use qaq to clear
vmap 1 "Ay
vmap <C-1> "Ay
nmap <C-1> "Ayy
nnoremap <M-1> "ap
vmap 2 "By
vmap <C-2> "By
nmap <C-2> "Byy
nnoremap <M-2> "bp
vmap 3 "Cy
vmap <C-3> "Cy
nmap <C-3> "Cyy
nnoremap <M-3> "cp

" Vim typescrip.tsx support (experimental)
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = '--jsx "react" --target "ES2016" --lib "ES2015"'
" Lightline config
let g:lightline = {
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" Sparkup config
let g:sparkupExecuteMapping = '<c-e>'
let g:sparkupNextMapping = '<c-s>'
let g:sparkupMapsNormal = 1

" Terminal config
tnoremap <Esc> <C-\><C-n>gg
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

function! Terminal()
   split
   enew
   terminal
endfunction

augroup AutoTerminal
   autocmd!
   autocmd BufEnter,TermOpen term\:\/\/* setlocal nocursorline | setlocal nocursorcolumn | setlocal nonumber
augroup END

" Vim tmux navigator config
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <A-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <A-j> :TmuxNavigateDown<CR>
nnoremap <silent> <A-k> :TmuxNavigateUp<CR>
nnoremap <silent> <A-l> :TmuxNavigateRight<CR>
inoremap <silent> <A-h> <esc>:TmuxNavigateLeft<CR>
inoremap <silent> <A-j> <esc>:TmuxNavigateDown<CR>
inoremap <silent> <A-k> <esc>:TmuxNavigateUp<CR>
inoremap <silent> <A-l> <esc>:TmuxNavigateRight<CR>
nnoremap <silent> <A-b> <esc>:TmuxNavigatePrevious<CR>

let g:neotags_enabled = 1

call plug#begin('~/.vim/plugged')
Plug 'kien/rainbow_parentheses.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'xolox/vim-misc'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'saihoooooooo/glowshi-ft.vim'
Plug 'Shougo/vimproc.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'gregsexton/MatchTag'
Plug 'tomtom/tcomment_vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'leafgarland/typescript-vim'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'alfredodeza/coveragepy.vim'
"Plug 'Floobits/floobits-neovim'
Plug 'w0rp/ale'

" Experiments
Plug 'christoomey/vim-tmux-navigator'
Plug 'janko-m/vim-test'
call plug#end()

nmap <silent> <leader>r :TestNearest<CR>
let test#strategy = "dispatch"

let g:ale_fixers = {
\   'javascript': ['eslint'],
\}

let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:airline#extensions#ale#enabled = 1

let g:lightline.component_expand = {
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \ }

let g:lightline.active = { 'right': [[ 'linter_errors', 'linter_warnings', 'linter_ok' ]] }
