" Filetype overrides
" Put in first directory on runtimepath
" (type :set runtimepath to display)

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.sql          setfiletype sqlserver
  au! BufRead,BufNewFile *.json         setfiletype javascript
  au! BufRead,BufNewFile *.ccsbmuproj   setfiletype javascript
augroup END
