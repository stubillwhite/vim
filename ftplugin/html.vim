if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

silent execute 'source '.g:MyVimScripts.'/firefox-preview.vim'

map <buffer> <Leader>pr :FirefoxPreviewTogglePreview html<CR>
