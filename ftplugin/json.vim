if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

silent execute ':EditorConfigCode'

function s:FormatJSON() range
    silent execute '%!python -m json.tool'
endfunction
command -nargs=0 FormatJSON call s:FormatJSON(<f-args>)
command! -range=% -nargs=0 FormatJSON <line1>,<line2>call s:FormatJSON(<f-args>)

vmap <Leader>f :FormatJSON<CR>
nmap <Leader>f :FormatJSON<CR>

