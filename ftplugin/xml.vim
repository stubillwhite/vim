if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

silent execute ':EditorConfigCode'

" Treat [@_-.:] as part of an identifier, not as punctuation
set iskeyword=@,48-57,_,192-255,-,.,:

function s:FormatXml() range
    " TODO: Should use something better than $my_home, like a variable defined in here
    silent execute a:firstline.','.a:lastline.'!java -jar '.$my_home.'\my_stuff\srcs\java\xml-formatter\xml-formatter.jar'
endfunction
command! -range=% -nargs=0 FormatXml <line1>,<line2>call s:FormatXml(<f-args>)

vmap <Leader>f :FormatXml<CR>
nmap <Leader>f :FormatXml<CR>
