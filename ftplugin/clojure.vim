if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

set suffixesadd=.clj
set path=.,src/**,testsrc/**

"------------------------------------------------------------------------------
" Configuration Slimv
"------------------------------------------------------------------------------

" For Clojure 1.2.0
" let g:slimv_lisp = 'java -cp c:/dev/MyProjects/Clojure/clojure-1.2.0/clojure.jar;C:/dev/MyProjects/Clojure/clojure-contrib-1.2.0/target/clojure-contrib-1.2.0.jar;C:/Users/IBM_ADMIN/.vim/bundle/slimv.vim/swank-clojure clojure.main'

" For Clojure 1.3.0
let g:slimv_lisp = 'java -cp c:/dev/MyProjects/Clojure/clojure-1.3.0/clojure-1.3.0.jar;C:/Users/IBM_ADMIN/.vim/bundle/slimv.vim/swank-clojure;c:/dev/MyProjects/Clojure/CQRS/src clojure.main'
"let g:slimv_lisp = 'java -cp c:/dev/MyProjects/Clojure/clojure-1.3.0/clojure-1.3.0.jar;C:/Users/IBM_ADMIN/.vim/bundle/slimv.vim/swank-clojure clojure.main'

let g:slimv_lisp = '' " use lein swank

" <leader>e evaluate
" <leader>r repl
" nnoremap <Leader>e normal cqq<CR>
" nnoremap <Leader>r normal cqp<CR>
