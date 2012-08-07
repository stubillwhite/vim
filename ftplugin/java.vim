if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

silent execute ':EditorConfigCode'

" Highlighting options
let java_highlight_functions="style"    " Identify functions by naming style
let java_allow_cpp_keywords=1           " No CPP code compatability
let java_ignore_javadoc=1               " No highlighting of Javadoc elements

" Make options
set makeprg=ant
set errorformat=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

