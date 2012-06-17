" FILE: white.vim
"
" DESCRIPTION: 
" Reverse-video colour settings; only suitable for the GUI.

set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "white"

hi Normal       guifg=gray80            guibg=gray10            gui=NONE

hi Comment      guifg=DarkSeaGreen3     guibg=bg                gui=NONE
hi Constant     guifg=burlywood1        guibg=bg                gui=NONE
hi Identifier   guifg=white             guibg=bg                gui=NONE
hi Statement    guifg=CadetBlue2        guibg=bg                gui=NONE
hi PreProc      guifg=Pink2             guibg=bg                gui=NONE
hi Type         guifg=CadetBlue2        guibg=bg                gui=NONE
hi Special      guifg=burlywood1        guibg=bg                gui=NONE
"hi Underlined
"hi Ignore
"hi Error

" Links
hi! link CursorIM       Cursor
hi! link VertSplit      StatusLineNC
hi! link Pmenu          StatusLineNC
hi! link IncSearch      Search 
hi! link LineNr         ErrorMsg
hi! link ModeMsg        ErrorMsg
hi! link MoreMsg        ErrorMsg
hi! link Question       ErrorMsg
hi! link WarningMsg     ErrorMsg
hi! link Todo           ErrorMsg
hi! link Title          ErrorMsg
hi! link WildMenu       Visual

" highlight-groups
hi Cursor       guifg=bg                guibg=fg                gui=NONE
hi Directory    guifg=thistle           guibg=bg                gui=NONE

hi DiffAdd      guifg=fg                guibg=aquamarine4       gui=NONE
hi DiffChange   guifg=fg                guibg=royalblue4        gui=NONE
hi DiffDelete   guifg=fg                guibg=indianred4        gui=NONE
hi DiffText     guifg=fg                guibg=royalblue3        gui=NONE

hi ErrorMsg     guifg=gray100           guibg=bg                gui=bold
hi Folded       guifg=fg                guibg=darkslategray     gui=italic
hi FoldColumn   guifg=fg                guibg=bg                gui=italic
hi NonText      guifg=gray50            guibg=bg                gui=NONE
hi Search       guifg=gray100           guibg=darkslategray     gui=NONE
hi SpecialKey   guifg=LightGoldenrod1   guibg=bg                gui=NONE
hi StatusLine   guifg=gray100           guibg=PaleTurquoise4    gui=bold
hi StatusLineNC guifg=fg                guibg=gray30            gui=NONE
hi Visual       guifg=fg                guibg=gray40            gui=NONE
hi VisualNOS    guifg=fg                guibg=gray40            gui=NONE
