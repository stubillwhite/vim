if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

silent execute ':EditorConfigCode'

let g:SrchPattern='*.py'

