" vim:fdm=marker

" Stuff to sort out                                                         {{{1
" ==============================================================================

"  - Look at repeat.vim
"  - Better XML completion
"  - Sort out :compiler option
"  - Better search functionality

" Plugins                                                                   {{{1
" ==============================================================================

set nocompatible 
filetype off     

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Set <Leader> to something easier to reach
let mapleader=","               
let g:mapleader="," 

" Core                              {{{2
" ======================================

" Vundle (required)
Bundle 'gmarik/vundle'

" Utility functions used by oher plugins (required)
Bundle 'L9'           

" Bundles                           {{{2
" ======================================

" Testing
" ack               git://github.com/mileszs/ack.vim.git

" Align data in columns
Bundle 'Align'

" Simple buffer navigation
Bundle 'bufexplorer.zip'
nmap <Leader>b :BufExplorer<CR>

" Fuzzy file finder
Bundle 'ctrlp.vim'
let g:ctrlp_by_filename=1           " Default to file mode, not full path
let g:ctrlp_clear_cache_on_exit=0   " Keep the cache across sessions
nmap <Leader>p :CtrlP<CR>

" Automatically close quotes, brackets, etc
Bundle 'delimitMate.vim'

" Colorschemes
Bundle 'flazz/vim-colorschemes'

" Visualise the undo graph
Bundle 'Gundo'
nnoremap <Leader>u :GundoToggle<CR>

" Easy multi-language commenting 
Bundle 'The-NERD-Commenter'

" Easy file browsing
Bundle 'The-NERD-tree'
nmap <Leader>e :NERDTreeToggle<CR>

" Indentation-based text objects for Python
Bundle 'vim-indent-object'



"Bundle 'ragtag.vim'


" SQL language
Bundle 'sqlserver.vim'

" Adds surround text block
Bundle 'surround.vim'

" Tag autocompletion
" Bundle 'closetag.vim'
" Bundle 'HTML-AutoCloseTag'
Bundle 'xml.vim'

" Experimental
Bundle 'vim-orgmode'
Bundle 'mediawiki'

" Enable filetype autodetection and indent
filetype plugin indent on

" Functions                                                                 {{{1
" ==============================================================================

" General Vim functions             {{{2
" ======================================

" Configure for code editing
function s:EditorConfigCode()
    set textwidth=0
    set noautoindent
    set nosmarttab
    silent execute ':Maximise'
endfunction
command -nargs=0 EditorConfigCode call s:EditorConfigCode()

" Configure for text editing
function s:EditorConfigText()
    set textwidth=80
    set autoindent
    set smarttab
endfunction
command -nargs=0 EditorConfigText call s:EditorConfigText()

" Set all the relevant tab options to the specified level
function s:TabStop(n)
    silent execute 'set tabstop='.a:n
    silent execute 'set shiftwidth='.a:n
    silent execute 'set softtabstop='.a:n
endfunction
command -nargs=1 TabStop call s:TabStop(<f-args>)

" Maximise the window
function s:MaximiseWindow()
    if has('unix')
        set lines=38 columns=125
    else
        " Alt-space x to maximise the window
        silent exec 'simalt ~x'
    endif
endfunction
command -nargs=0 Maximise call s:MaximiseWindow()

" Create the specified directory if it doesn't exist
function s:CreateDirectory(path)
   if !isdirectory(a:path)
      call mkdir(a:path, 'p')
  endif
endfunction

" Switch off diff mode for the current window
function s:NoDiffThis()
    silent execute ':diffoff | set nowrap'
endfunction
command -nargs=0 NoDiffThis call s:NoDiffThis(<f-args>)

" Text functions                    {{{2
" ======================================

" Convert MS Office fancy puctuation into ASCII
function s:FixSmartPunctuation()
    silent! %s/\%u0091/'/g
    silent! %s/\%u0092/'/g
    silent! %s/\%u0093/"/g
    silent! %s/\%u0094/"/g
    silent! %s/\%u2019/'/g
    silent! %s/\%u2026/.../g
endfunction
command -nargs=0 FixSmartPunctuation call s:FixSmartPunctuation(<f-args>)

" Strip trailing whitespace characters from the entire file or a range
function s:StripTrailingWhitespace() range
    let l:save_search=@/
    let l:save_cursor = getpos('.')
    silent execute ':'.a:firstline.','a:lastline.'s/\s\+$//e'
    let @/=l:save_search
    silent call setpos('.', l:save_cursor)
endfunction
command -range=% StripTrailingWhitespace <line1>,<line2> call s:StripTrailingWhitespace()

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
set showmode                    " Show the active mode
set incsearch                   " Search incrementally
set hlsearch                    " Search highlighting
set history=1000                " Keep more history
set visualbell                  " No beep
set expandtab                   " No tabs
set nowrap                      " No wrapping text
set nojoinspaces                " Single-space when joining sentences
set title                       " Set the title of the terminal
set ignorecase                  " Case insensitive by default...
set smartcase                   " ...but case sensitive if term includes uppercase
set scrolloff=2                 " Keep some context when scrolling vertically
set sidescrolloff=2             " Keep some context when scrolling horizontally
set nostartofline               " Keep horizontal cursor position when scrolling
set formatoptions+=n            " Format respects numbered/bulleted lists
set virtualedit=block           " Virtual edit in visual blocks only
set timeoutlen=500              " Timeout to press a key combination
set report=0                    " Always report changes
set undofile                    " Allow undo history to persist between sessions
set path=.,,.\dependencies\**   " Search path
set tags=./tags,../tags,tags    " Default tags files
set listchars=tab:>-,eol:$      " Unprintable characters to display
TabStop 4                       " Default to 4 spaces per tabstop

syntax on                       " Syntax highlighting
colorscheme white               " My color scheme

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
set wildignore+=*.class,*.obj,*.pyc        
set wildignore+=.hg,.git,.svn

" GUI options - strip off items to maximise screen size
set guioptions-=m               " No menu
set guioptions-=T               " No toolbar
set guioptions-=r               " No right scrollbar
set guioptions-=R               " No right scrollbar on split
set guioptions-=l               " No left scrollbar
set guioptions-=L               " No left scrollbar on split
set guioptions-=b               " No bottom scrollbar
set guioptions+=c               " Use console dialogs rather than pop-up

" Misc options
let g:netrw_altv=1              " Netrw vertical split puts cursor on the right
let html_use_css=1              " TOhtml command should use CSS

" Standard plugin to allow % to match keywords as well as braces
runtime macros/matchit.vim

" Store Undo/Backup/Swap files in a temporary directory
silent execute ':set undodir='.g:TmpDir.'/undo'
silent execute ':set backupdir='.g:TmpDir.'/backup'
silent execute ':set directory='.g:TmpDir.'/swap'
call s:CreateDirectory(&undodir)
call s:CreateDirectory(&backupdir)
call s:CreateDirectory(&directory)

" TODO Look at symlinks and windows
" set nobackup                    " do not keep backups after close
" set nowritebackup               " do not keep a backup while working
" set noswapfile                  " don't keep swp files either

" Error and make files
set shellpipe=2>&1\ \|\ tee
silent execute 'set errorfile='.g:TmpDir.'/error_file.txt'
silent execute 'set makeef='.g:TmpDir.'/make_error_file.txt'
silent execute 'set errorfile='.g:TmpDir.'/error_file.txt'

" Autocmds
augroup VimrcEditingAutocommands

    " When editing a file, always jump to the last known cursor position
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

    " Normalise splits when resizing
    au VimResized * exe "normal! \<C-w>="

augroup END

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
        silent execute ':Maximise'
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

function s:SearchForWord(wrd)
    " Default to searching for the current file extension
    if !exists("g:SrchPattern")
        let g:SrchPattern='*.'.expand("%:e")
    endif

    let g:SrchPattern=input('Pattern: ', g:SrchPattern)
    let cmd=':grep '.a:wrd.' '.g:SrchPattern
    silent execute cmd
endfunction
command -nargs=1 Search call s:SearchForWord(<f-args>)

" File types                                                                {{{1
" ==============================================================================

augroup VimrcFileTypeAutocommands

    " Markdown
    au BufRead,BufNewFile *.md setlocal filetype=markdown

augroup END


" Key mappings                                                              {{{1
" ==============================================================================

" Use semi-colon as an alias for colon for easier access to Ex commands
nnoremap ; :

" Swap ` and ' because ` functionality is more useful but the key is hard to reach
nnoremap ' `
nnoremap ` '

" Quick way to edit .vimrc
nmap <Leader>v :e C:/Users/IBM_ADMIN/my_local_stuff/home/my_stuff/srcs/vim/vimrc.vim<CR>

" [AccuRev] Diff current file with backed
nnoremap <Leader>d :silent! !start accurev diff -b <c-R>%<CR>

" Search for the word currently under the cursor
nnoremap <C-K> :Search <C-R><C-W>

" Show unprintable characters
nmap <Leader>l :set list!<CR>

" Strip trailing whitespace characters
nnoremap <silent> <Leader>w :StripTrailingWhitespace<CR>
vnoremap <silent> <Leader>w :StripTrailingWhitespace<CR>

" Initial configuration                                                     {{{1
" ==============================================================================

" Unless we reconfigure for code editing, default to text editing mode
silent execute ':EditorConfigText'



""" " autocmd that will set up the w:created variable
""" autocmd VimEnter * autocmd WinEnter * let w:created=1
""" 
""" " Consider this one, since WinEnter doesn't fire on the first window created when Vim launches.
""" " You'll need to set any options for the first window in your vimrc,
""" " or in an earlier VimEnter autocmd if you include this
""" autocmd VimEnter * let w:created=1
""" 
""" " Example of how to use w:created in an autocmd to initialize a window-local option
""" autocmd WinEnter * if !exists('w:created') | setlocal nu | endif
""" 
""" If you want the autocmd for setting the w:created variable to be contained in a given augroup, use the optional group argument to the autocmd, for example:
""" 
""" augroup mygroup
"""   au!
"""   autocmd VimEnter * autocmd mygroup WinEnter * let w:created=1
""" augroup END

