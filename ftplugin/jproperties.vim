if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

silent execute ':EditorConfigCode'

" Treat [.] as part of an identifier, not as punctuation
set iskeyword+=.
