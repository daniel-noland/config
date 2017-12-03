" My custom vim theme based on darkblue theme by
" Maintainer:	Bohdan Vlasyuk <bohdan@vstu.edu.ua>
" Last Change:	2008 Jul 18

" darkblue -- for those who prefer dark background
" [note: looks bit uglier with come terminal palettes,
" but is fine on default linux console palette.]

set bg=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let g:colors_name = "dan_custom"

hi Normal		guifg=lightgray guibg=#000000						ctermfg=lightgray ctermbg=NONE
" Vim color file
hi ErrorMsg		guifg=#ffffff guibg=#287eff						ctermfg=darkcyan ctermbg=none
hi Visual		guifg=#8080ff guibg=fg		gui=reverse				ctermfg=40 ctermbg=17 cterm=bold
"hi VisualNOS	guifg=#8080ff guibg=fg		gui=reverse,underline	ctermfg=lightblue ctermbg=fg cterm=reverse,underline
hi Todo			guifg=#d14a14 guibg=#1248d1						cterm=bold ctermfg=red	ctermbg=none
hi Search		guifg=#90fff0 guibg=#2050d0						ctermfg=white ctermbg=17 cterm=bold term=bold cterm=bold
hi IncSearch	guifg=darkblue guibg=darkgray							ctermfg=darkblue ctermbg=darkgray term=bold cterm=bold

hi SpecialKey		guifg=cyan			ctermfg=darkcyan
hi Directory		guifg=cyan			ctermfg=cyan
hi Title			guifg=magenta gui=none ctermfg=magenta cterm=bold
hi WarningMsg		guifg=red			ctermfg=red
hi WildMenu			guifg=yellow guibg=black ctermfg=yellow ctermbg=black cterm=none term=none
hi ModeMsg			guifg=#22cce2		ctermfg=lightblue
hi MoreMsg			ctermfg=darkgreen	ctermfg=darkgreen
hi Question			guifg=green gui=none ctermfg=green cterm=none
hi NonText			guifg=#0030ff		ctermfg=darkblue

hi StatusLine	guifg=cyan guibg=black gui=none		ctermfg=cyan ctermbg=none term=bold cterm=bold
hi StatusLineNC	guifg=cyan guibg=black gui=none		ctermfg=cyan ctermbg=none term=none cterm=none
hi VertSplit	guifg=black guibg=#101010 gui=none		ctermfg=darkgray ctermbg=none term=none cterm=bold

hi Folded	guifg=black guifg=#33A3FF guibg=#452525			ctermfg=60 ctermbg=none cterm=bold term=bold
hi FoldColumn	guifg=darkgray guibg=#050505			ctermfg=darkgray ctermbg=none cterm=bold term=bold
hi LineNr	guifg=#90f020			ctermfg=darkgreen cterm=none

hi DiffAdd	guifg=lightgray guibg=#106010	ctermbg=darkgreen ctermfg=white term=none cterm=none
hi DiffChange	guifg=lightgray guibg=#101060 ctermbg=magenta ctermfg=white cterm=none
hi DiffDelete	guifg=lightgray guibg=#601010 ctermfg=lightgray ctermbg=Red gui=bold guifg=Blue guibg=DarkCyan
hi DiffText	guifg=lightgray cterm=bold ctermbg=red gui=bold guibg=Red

hi Cursor	guifg=cyan guibg=#454585 ctermfg=cyan ctermbg=yellow cterm=bold term=bold
hi lCursor	guifg=cyan guibg=white ctermfg=white ctermbg=cyan cterm=bold term=bold
hi CursorColumn cterm=bold ctermfg=none ctermbg=none guibg=#151515
hi CursorLine cterm=bold ctermbg=none guibg=#151515 term=bold


hi Comment	guifg=#80a0ff ctermfg=cyan
hi Constant	ctermfg=magenta guifg=#ffa0a0 cterm=none
hi Special	ctermfg=brown guifg=Orange cterm=none gui=none
hi Identifier	ctermfg=cyan guifg=#40ffff cterm=none
hi Statement	ctermfg=yellow ctermbg=none cterm=none guifg=#ffff60 gui=none
hi PreProc	ctermfg=magenta guifg=#ff80ff gui=none cterm=none
hi type		ctermfg=green guifg=#60ff60 gui=none cterm=none
hi Underlined	cterm=underline term=underline
"hi Ignore	guifg=bg ctermfg=bg

" suggested by tigmoid, 2008 Jul 18
hi Pmenu guifg=#c0c0c0 guibg=#404080
hi PmenuSel guifg=#c0c0c0 guibg=#2050d0
hi PmenuSbar guifg=blue guibg=darkgray
hi PmenuThumb guifg=#c0c0c0

hi TabLine		  term=bold  cterm=bold ctermfg=cyan ctermbg=none gui=bold guifg=darkcyan guibg=black
hi TabLineFill	  term=bold cterm=none ctermfg=darkcyan ctermbg=none gui=bold guifg=blue guibg=black

"working on vim diff hilighting
highlight DiffAdd cterm=NONE ctermfg=lightblue ctermbg=22 gui=NONE guifg=bg guibg=#208020 term=bold
highlight DiffDelete cterm=NONE ctermfg=lightblue ctermbg=52 gui=NONE guifg=bg guibg=#802020
highlight DiffChange cterm=NONE ctermfg=161 ctermbg=18 gui=NONE guifg=bg guibg=#802080 term=bold
highlight DiffText cterm=NONE ctermfg=black ctermbg=darkgray gui=NONE guifg=bg guibg=gray

" This section is shamelessly stolen from the venerable Lokaltog's
" distinguished color scheme.  Thanks, Localtog :)

"Sign column
highlight SignColumn cterm=bold ctermfg=darkgreen ctermbg=none guibg=black guifg=darkgreen

if ! has('gui_running')
	if &t_Co != 256
		echoe 'The ' . g:colors_name . ' color scheme requires gvim or a 256-color terminal'
		finish
	endif
endif
" }}}
" Color dictionary parser {{{
function! s:ColorDictParser(color_dict)
	for [group, group_colors] in items(a:color_dict)
		exec 'hi ' . group
					\ . ' ctermfg=' . (group_colors[0] == '' ? 'NONE' :       group_colors[0])
					\ . ' ctermbg=' . (group_colors[1] == '' ? 'NONE' :       group_colors[1])
					\ . '   cterm=' . (group_colors[2] == '' ? 'NONE' :       group_colors[2])
					\
					\ . '   guifg=' . (group_colors[3] == '' ? 'NONE' : '#' . group_colors[3])
					\ . '   guibg=' . (group_colors[4] == '' ? 'NONE' : '#' . group_colors[4])
					\ . '     gui=' . (group_colors[5] == '' ? 'NONE' :       group_colors[5])
	endfor
endfunction
" }}}

"	   | Highlight group                |  CTFG |  CTBG |    CTAttributes | || |   GUIFG |    GUIBG |   GUIAttributes |
"	   |--------------------------------|-------|-------|-----------------| || |---------|----------|-----------------|
call s:ColorDictParser({
			\   'WildMenu'                    : [     54,    234,               '',      '1c1c1c',  'ffffff',               '']
			\ , 'Directory'                   : [    143,     '',           'bold',      'afaf5f',        '',           'bold']
			\ , 'Underlined'                  : [    130,     '',               '',      'af5f00',        '',               '']
			\
			\ , 'SyntasticWarning'            : [    220,     54,               '',      'ffff87',  '875f00',           'bold']
			\ , 'SyntasticError'              : [    202,     52,               '',      'ffff87',  '875f00',           'bold']
			\ })

hi link htmlTag            xmlTag
hi link htmlTagName        xmlTagName
hi link htmlEndTag         xmlEndTag

hi link phpCommentTitle    vimCommentTitle
hi link phpDocTags         vimCommentString
hi link phpDocParam        vimCommentTitle

hi link diffAdded          DiffAdd
hi link diffChanged        DiffChange
hi link diffRemoved        DiffDelete

" Syntastic config
hi syntasticError guifg=red ctermfg=red guibg=NONE ctermbg=NONE
hi syntasticWarning ctermfg=yellow guifg=yellow guibg=NONE ctermbg=NONE
hi syntasticStyle ctermfg=202 guifg=#ff5f00 guibg=NONE ctermbg=NONE
