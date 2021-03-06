silent execute ':EditorConfigCode'

" Treat [@_-.:] as part of an identifier, not as punctuation
set iskeyword+=@
set iskeyword+=_
set iskeyword+=-
set iskeyword+=.
set iskeyword+=:

function! s:FormatXml() range
    " TODO: Should use something better than $my_home, like a variable defined in here
    silent execute a:firstline.','.a:lastline.'!java -jar '.$my_home.'\my_stuff\srcs\java\xml-formatter\xml-formatter.jar'
endfunction
command! -range=% -nargs=0 FormatXml <line1>,<line2>call s:FormatXml(<f-args>)

vnoremap <Leader>f :FormatXml<CR>
nnoremap <Leader>f :FormatXml<CR>

silent execute 'AlignCtrl l=p1P0I'

" Spaces for XML files
set expandtab

" TODO -- Stick this in a function
"" Enable folding but turn it off on entry to the file
"let g:xml_syntax_folding=1
"set foldmethod=syntax
"set foldlevel=1
"set nofoldenable
