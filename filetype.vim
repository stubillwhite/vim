" Filetype overrides
" Put in $HOME/vimfiles/filetype.vim

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.sql          setfiletype sqlserver
  au! BufRead,BufNewFile *.db2          setfiletype sqlserver
  au! BufRead,BufNewFile *.json         setfiletype javascript
  au! BufRead,BufNewFile *.ccsbmuproj   setfiletype xml
  au! BufRead,BufNewFile *.proj         setfiletype xml
  au! BufRead,BufNewFile *.xml.template setfiletype xml
  au! BufNewFile,BufRead *.gradle       setfiletype groovy
  au! BufNewFile,BufRead *.scala        setfiletype scala
augroup END
