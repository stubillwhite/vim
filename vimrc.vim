" vim:fdm=marker

" Stuff to sort out                                                         {{{1
" ==============================================================================

"  - Look at repeat.vim
"  - Better XML completion
"  - Sort out :compiler option
"  - Sort out fuzzy finder and tag building for project files only
"  - Better search functionality

" Vundle                                                                    {{{1
" ==============================================================================

set nocompatible 
filetype off     

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles                           {{{2
" ======================================

" Vundle (required)
Bundle 'gmarik/vundle'

" Utility functions used by oher plugins (required)
Bundle 'L9'           

" SQL language
Bundle 'sqlserver.vim'

" Easy multi-language commenting 
Bundle 'The-NERD-Commenter'

" Adds surround text block
Bundle 'surround.vim'

" Visualise the undo graph
Bundle 'Gundo'

" Fuzzy search across buffers/files/tags/etc
Bundle 'FuzzyFinder'  

" Align data in columns
Bundle 'Align'

" Tag autocompletion
" Bundle 'closetag.vim'
" Bundle 'HTML-AutoCloseTag'
Bundle 'xml.vim'

" Experimental
Bundle 'vim-orgmode'
Bundle 'mediawiki'

"" " Clojure
"" Bundle 'tpope/vim-fireplace'
"" "Bundle 'tpope/vim-classpath'
"" Bundle 'guns/vim-clojure-static'
"" " EMACS Slimv for Lisp editing
"" Bundle 'paredit.vim'

""
" Old Clojure
Bundle 'slimv.vim'    
"Bundle 'VimClojure'    


" Enable filetype autodetection and indent
filetype plugin indent on

" Functions                                                                 {{{1
" ==============================================================================

function EditorConfigCode()
    set textwidth=0
    set noautoindent
    set nosmarttab
    silent execute ':Maximise'
endfunction
command -nargs=0 EditorConfigCode call EditorConfigCode()

function EditorConfigText()
    set textwidth=80
    set autoindent
    set smarttab
endfunction
command -nargs=0 EditorConfigText call EditorConfigText()

function TabStop(n)
    execute 'set tabstop='.a:n
    execute 'set shiftwidth='.a:n
endfunction
command -nargs=1 TabStop call TabStop(<f-args>)

function MaximiseWindow()
    if has('unix')
        set lines=38 columns=125
    else
        " Alt-space x to maximise the window
        silent exec 'simalt ~x'
    endif
endfunction
command -nargs=0 Maximise call MaximiseWindow()

function s:CreateDirectory(path)
   if !isdirectory(a:path)
      call mkdir(a:path, 'p')
  endif
endfunction

function NoDiffThis()
    silent execute ':diffoff | set nowrap'
endfunction
command -nargs=0 NoDiffThis call NoDiffThis(<f-args>)

" Text functions                    {{{2
" ======================================

" Underline the current text
function Underline(char)
    let len = col("$") - 1
    silent execute ":normal $a"
    silent execute ":normal ".len."i".a:char
endfunction
command -nargs=1 Underline call Underline(<f-args>)

" Convert MS Office fancy puctuation into AsCII
function FixSmartPunctuation()
    silent! %s/\%u0091/'/g
    silent! %s/\%u0092/'/g
    silent! %s/\%u0093/"/g
    silent! %s/\%u0094/"/g
    silent! %s/\%u2019/'/g
    silent! %s/\%u2026/.../g
endfunction
command -nargs=0 FixSmartPunctuation call FixSmartPunctuation(<f-args>)

function GenerateGUIDs(count)
    silent execute ':split'
    silent execute ':ene'
    silent execute ':read !"c:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Bin\Uuidgen.Exe" -n'.a:count
endfunction
command -nargs=+ GenerateGUIDs call GenerateGUIDs(<f-args>)

" While I'm playing with fonts...
"
function FontLucida()
    silent execute 'set guifont=Lucida_Console:h10:cDEFAULT'
endfunction
command -nargs=* FontLucida call FontLucida(<f-args>)

function FontInconsolata()
    silent execute 'set guifont=Inconsolata:h12:cANSI'
endfunction
command -nargs=* FontInconsolata call FontInconsolata(<f-args>)

function FontAnonymous()
    silent execute 'set guifont=Anonymous_Pro:h12:cANSI'
endfunction
command -nargs=* FontAnonymous call FontAnonymous(<f-args>)

" Settings                                                                  {{{1
" ==============================================================================

" Paths
if has('unix')
    let g:Home='~'
else
    let g:Home='c:/users/IBM_ADMIN/my_local_stuff/home'
endif
let g:TmpDir=g:Home.'/.vimtmp'
let g:MyVimScripts=g:Home.'/my_stuff/srcs/vim'

" Default to Vim mode, and Windows behaviour
set nocompatible
source $VIMRUNTIME/mswin.vim

" General settings
set backup                      " Use backup files
set hidden                      " Keep buffers open when not displayed
set ruler                       " Show the file position
set showcmd                     " Show incomplete commands
set incsearch                   " Use incremental searching
set hlsearch                    " Highlight search matches
set history=1000                " Keep more history
set visualbell                  " Don't beep, just flash
set expandtab                   " No tabs
set nowrap                      " Don't wrap text when displaying
set nojoinspaces                " Single-space when joining sentences
set ignorecase                  " Case insensitive by default
set scrolloff=2                 " Keep some context when scrolling vertically
set sidescrolloff=2             " Keep some context when scrolling horizontally
set timeoutlen=2000             " Timeout to press a key combination
set undofile                    " Allow undo history to persist between sessions
syntax on                       " Syntax highlighting
colorscheme white               " My color scheme
TabStop 4                       " Default to 4 spaces per tabstop

" Enable extended character sets
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
set guifont=Lucida_Console:h10:cDEFAULT
set guifontwide=NSimsun:h10

" Command / file completion
set wildmenu                    " Display options when tab completing
set wildmode=list:full          " List options but complete to full
set wildignore=
set wildignore=*.class,*.*~

" GUI options - strip off items to maximise screen size
set guioptions-=m               " No menu
set guioptions-=T               " No toolbar
set guioptions-=r               " No right scrollbar
set guioptions-=R               " No right scrollbar on split
set guioptions-=l               " No left scrollbar
set guioptions-=L               " No left scrollbar on split
set guioptions-=b               " No bottom scrollbar

" Misc options
let g:netrw_altv=1              " Netrw vertical split puts cursor on the right
let html_use_css=1              " TOhtml command should use CSS
let mapleader=","               " Set <Leader> to something easier to reach

" Swap ` and ' because ` functionality is more useful but the key is hard to reach
nnoremap ' `
nnoremap ` '

" Standard plugin to allow % to match keywords as well as braces
runtime macros/matchit.vim

" Store Undo/Backup/Swap files in a temporary directory
silent execute ':set undodir='.g:TmpDir.'/undo'
silent execute ':set backupdir='.g:TmpDir.'/backup'
silent execute ':set directory='.g:TmpDir.'/swap'
call s:CreateDirectory(&undodir)
call s:CreateDirectory(&backupdir)
call s:CreateDirectory(&directory)

" Error and make files
set shellpipe=2>&1\ \|\ tee
silent execute 'set errorfile='.g:TmpDir.'/error_file.txt'
silent execute 'set makeef='.g:TmpDir.'/make_error_file.txt'
silent execute 'set errorfile='.g:TmpDir.'/error_file.txt'

" Autocmds
augroup VimrcEditingAutocommands
autocmd
  " When editing a file, always jump to the last known cursor position
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" Unless we reconfigure this for code editing, default to text editing mode
silent execute 'call EditorConfigText()'

" File comparison options
set diffopt=filler,iwhite
if has('unix')
    set diffexpr=
else
    set diffexpr=MyDiff()
    function MyDiff()
      let opt = ''
      if &diffopt =~ 'icase'  | let opt = opt.'-i ' | endif
      if &diffopt =~ 'iwhite' | let opt = opt.'-b ' | endif
      silent execute '!"'.$VIMRUNTIME.'/diff.exe" -r '.opt.v:fname_in.' '.v:fname_new.' > '.v:fname_out
    endfunction
endif

" Special configuration for a diff window
function ConfigureGui()
    if &diff
        silent execute 'call MaximiseWindow()'
        let cmd = 'set titlestring=Diff\ (' . expand("%:t") . ')'
        silent execute cmd
    endif
endfunction
autocmd GUIEnter * call ConfigureGui()

" If we're not running on Unix then disable Unix EOL recognition
if !has('unix')
    set fileformats-=unix
endif

" Search                                                                    {{{1
" ==============================================================================

set grepprg=findstr\ /s\ /n
set grepformat=%f:%l:%m
let g:SrchPattern='*.txt'

function s:SearchForWord(wrd)
    let g:SrchPattern=input('Pattern: ', g:SrchPattern)
    let cmd=':grep '.a:wrd.' '.g:SrchPattern
    silent execute cmd
endfunction
command -nargs=1 Search call s:SearchForWord(<f-args>)

" Other scripts                                                             {{{1
" ==============================================================================

silent execute 'source '.g:MyVimScripts.'/make-tags.vim'
set tags=./tags,../tags,tags

" Key mappings                                                              {{{1
" ==============================================================================

nnoremap <Leader>u :GundoToggle<CR>
nnoremap <Leader>d :silent! !start accurev diff -b <c-R>%<CR>
nnoremap <C-K> :Search <C-R><C-W>
