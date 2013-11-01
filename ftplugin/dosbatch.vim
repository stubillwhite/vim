if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

set iskeyword+=%

silent execute ':EditorConfigCode'
