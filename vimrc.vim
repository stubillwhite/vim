" vim:fdm=marker

" Stuff to sort out                                                         {{{1
" ==============================================================================

"  - Sort out :compiler option
"  - Better search functionality
"  - Fix window maximisation
"     - Should be a no-op if already maximised
"     - Should be tied to GUI enter autocommand

" Prerequisites                                                             {{{1
" ==============================================================================

" Paths
if has('unix')
    let g:Home='~'
else
    let g:Home='c:/users/IBM_ADMIN/my_local_stuff/home'
endif
let g:TmpDir=g:Home.'/.vimtmp'
let g:MyVimScripts=g:Home.'/my_stuff/srcs/vim'

function SourceScript(fnam)
    let l:cmd='source '.g:MyVimScripts.'/'.a:fnam
    silent execute l:cmd
endfunction
command -nargs=1 SourceScript call SourceScript(<args>)

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
let g:Use_Powerline=0
if g:Use_Powerline
    Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
    set rtp+=C:\Users\IBM_ADMIN\.vim\bundle\powerline\powerline\bindings\vim
    set t_Co=256
    let g:Powerline_symbols='fancy'
    "let g:Powerline_symbols = 'compatible'
    set guifont=Ubuntu_Mono_derivative_Powerlin:h12:cANSI
    set guifont=Liberation_Mono_for_Powerline:h10:cANSI
    set laststatus=2
else
    set guifont=Lucida_Console:h10:cDEFAULT
endif

" Testing
" ack               git://github.com/mileszs/ack.vim.git

" Align data in columns
Bundle 'Align'

" Simple buffer navigation
Bundle 'bufexplorer.zip'
nmap <Leader>b :BufExplorer<CR>
let g:bufExplorerSortBy='name'      " Default sort by the name

" File locator
Bundle 'ctrlp.vim'
let g:ctrlp_by_filename=1           " Default to file mode, not full path
let g:ctrlp_clear_cache_on_exit=0   " Keep the cache across sessions
let g:ctrlp_custom_ignore='.*\.beforejunction$'
nmap <Leader>p :CtrlP<CR>

" Automatically close quotes, brackets, etc
Bundle 'delimitMate.vim'

" Colorschemes
Bundle 'flazz/vim-colorschemes'

" Visualise the undo graph
Bundle 'Gundo'
nnoremap <Leader>u :GundoToggle<CR>

" Easy toggling of the location and quickfix windows
Bundle 'milkypostman/vim-togglelist'
nmap <script> <silent> <Leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <Leader>q :call ToggleQuickfixList()<CR>

" Smarter repeat functionality
Bundle 'repeat.vim'

" Easy multi-language commenting 
Bundle 'The-NERD-Commenter'

" Easy file browsing
Bundle 'The-NERD-tree'
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=0
nmap <Leader>e :NERDTreeToggle<CR>
nmap <Leader>E :NERDTreeFind<CR>

" Incredibly useful text navigation and manipulation shortcuts
Bundle 'unimpaired.vim'

" Indentation-based text objects for Python
Bundle 'vim-indent-object'

" Python support
Bundle 'davidhalter/jedi-vim'
let g:jedi#auto_close_doc=0
let g:jedi#use_tabs_not_buffers=0
let g:jedi#use_splits_not_buffers="bottom"

" Use tab for completion
Bundle 'SuperTab'

" SQL language
Bundle 'sqlserver.vim'

" Adds surround text block
Bundle 'surround.vim'

" Tag autocompletion
Bundle 'xml.vim'

" Org-mode
Bundle 'vim-orgmode'
Bundle 'speeddating.vim'

" Experimental
"Bundle 'ragtag.vim'


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
    silent execute 'Maximise'
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
    silent execute 'diffoff | set nowrap'
endfunction
command -nargs=0 NoDiffThis call s:NoDiffThis(<f-args>)

" Text functions                    {{{2
" ======================================

" Convert MS Office fancy punctuation into ASCII
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
    silent execute a:firstline.','a:lastline.'s/\s\+$//e'
    let @/=l:save_search
    silent call setpos('.', l:save_cursor)
endfunction
command -range=% StripTrailingWhitespace <line1>,<line2> call s:StripTrailingWhitespace()

" Navigation functions              {{{2
" ======================================

function s:MakeTags()
    silent execute 'cd ..'
    silent execute '!make-tags.bat'
    silent execute 'cd -'
endfunction
command -nargs=0 MakeTags call s:MakeTags()

" Font functions                    {{{2
" ======================================

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
set guifontwide=NSimsun:h10

" Command / file completion
set noshellslash                " Backslashes for filenames for ZIP plugin
set wildmenu                    " Display options when tab completing
set wildmode=list:longest,full  " List options but complete to full
set wildignore=
set wildignore+=*.class,*.obj,*.pyc
set wildignore+=*/.hg/*,*/.git/*,*/.svn/*
set wildignore+=*/bld/*,*/bin/*

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
silent execute 'set undodir='.g:TmpDir.'/undo'
silent execute 'set backupdir='.g:TmpDir.'/backup'
silent execute 'set directory='.g:TmpDir.'/swap'
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

" Autocmds
augroup VimrcEditingAutocommands

    " When editing a file, always jump to the last known cursor position
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

    " Normalise splits when resizing
    au VimResized * exe "normal! \<C-w>="

    " Syntax highlight from the start for better accuracy
    au BufEnter * :syntax sync fromstart

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
        silent execute 'Maximise'
        let cmd = 'set titlestring=Diff\ (' . expand("%:t") . ')'
        silent execute cmd
    endif
endfunction
autocmd GUIEnter * call ConfigureGui()

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
    let cmd='grep '.a:wrd.' '.g:SrchPattern
    silent execute cmd
endfunction
command -nargs=1 Search call s:SearchForWord(<f-args>)

" File types                                                                {{{1
" ==============================================================================

augroup VimrcFileTypeAutocommands

    au BufRead,BufNewFile *.md         setlocal filetype=markdown
    au BufRead,BufNewFile *.log        setlocal filetype=log

augroup END

" Key mappings                                                              {{{1
" ==============================================================================

" <Space> in normal mode removes highlighted search
nnoremap <Space> :nohlsearch<Return>:echo "Search highlight off"<Return>

" Use semi-colon as an alias for colon for easier access to Ex commands. Unmap
" colon to force your fingers to use it.
nnoremap ; :
vnoremap ; :
"nnoremap : <Nop>
"vnoremap : <Nop>

" Swap ` and ' because ` functionality is more useful but the key is hard to reach
nnoremap ' `
nnoremap ` '

" Quick way to edit .vimrc
nmap <Leader>v :e C:/Users/IBM_ADMIN/my_local_stuff/home/my_stuff/srcs/vim/vimrc.vim<CR><CR>

" Quick way to edit AccuRev notes
nmap <Leader>a :e C:/Users/IBM_ADMIN/my_local_stuff/home/accurev.txt<CR><CR>

" [AccuRev] Diff current file with backed
nnoremap <Leader>d :silent! !start accurev diff -b <c-R>%<CR>

" Search for the word currently under the cursor
nnoremap <C-K> :Search <C-R><C-W>

" Show unprintable characters
nmap <Leader>w :set list!<CR>

" Strip trailing whitespace characters
nnoremap <silent> <Leader>W :StripTrailingWhitespace<CR>
vnoremap <silent> <Leader>W :StripTrailingWhitespace<CR>

" Force back-slashes to forward-slashes, and vice versa
vnoremap <silent> <Leader>/ :s/\\/\//g<CR>:nohlsearch<CR>
vnoremap <silent> <Leader>\ :s/\//\\/g<CR>:nohlsearch<CR>

" Map insert mode CTRL-Backspace to delete the previous word
imap <C-BS> <C-W>

" Initial configuration                                                     {{{1
" ==============================================================================

" Unless we reconfigure for code editing, default to text editing mode
silent execute 'EditorConfigText'



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

