" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
" Source repository: https://github.com/Lokaltog/vim-distinguished
" Slightly modified by Daniel Noland <daniel.noland+vim@gmail.com>

" Initialization {{{
	set background=dark

	hi clear
	if exists('syntax_on')
		syntax reset
	endif

	let g:colors_name = 'distinguished_dan'

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
	\ , 'Question'                    : [     74,     '',           'bold',      '5fafd7',        '',           'bold']
	\ , 'MoreMsg'                     : [    214,     '',           'bold',      'ffaf00',        '',           'bold']
	\ , 'WarningMsg'                  : [    202,     '',           'bold',      'ff5f00',        '',           'bold']
	\ , 'ErrorMsg'                    : [    196,     '',           'bold',      'ff0000',        '',           'bold']
	\
	\ , 'Comment'                     : [    243,     '',                '',      '767676',  '121212',               '']
	\ , 'vimCommentTitleLeader'       : [    250,     '',                '',      'bcbcbc',  '121212',               '']
	\ , 'vimCommentTitle'             : [    250,     '',                '',      'bcbcbc',  '121212',               '']
	\ , 'vimCommentString'            : [    245,     '',                '',      '8a8a8a',  '121212',               '']
	\ 
	\ , 'TabLine'                     : [    231,     '',               '',       'ffffff',  '444444',               '']
	\ , 'TabLineSel'                  : [    255,     '',           'bold',      'eeeeee',        '',           'bold']
	\ , 'TabLineFill'                 : [    240,     '',               '',      '585858',  '444444',               '']
	\ , 'TabLineNumber'               : [    160,     '',           'bold',      'd70000',  '444444',           'bold']
	\ , 'TabLineClose'                : [    245,     '',           'bold',      '8a8a8a',  '444444',           'bold']
	\ 
	\ , 'SpellCap'                    : [    231,     '',           'bold',      'ffffff',  '0087af',           'bold']
	\ 
	\ , 'SpecialKey'                  : [    239,     '',               '',      '4e4e4e',        '',               '']
	\ , 'NonText'                     : [     88,     '',               '',      '870000',        '',               '']
	\ 
	\ , 'TODO'                        : [    228,     '',           'bold',      'ffff87',  '875f00',           'bold']
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
