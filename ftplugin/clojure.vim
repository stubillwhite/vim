if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

set suffixesadd=.clj
set path=.,src/**,testsrc/**
