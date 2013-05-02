if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

silent execute 'source '.g:MyVimScripts.'/firefox-preview.vim'

let g:MarkdownPath=g:Home.'/utils/bin/Markdown/Markdown.pl'

python << EOF
import os
import subprocess

def executeShellCmd(cmd, dir=None):
    try:
        tmpfile = os.tmpfile()
        startPos = tmpfile.tell()
        retcode = subprocess.call(cmd, stdin=subprocess.PIPE, stdout=tmpfile, stderr=tmpfile, shell=True)
        tmpfile.seek(startPos)
        output = tmpfile.readlines()
        tmpfile.close()

    except OSError, e:
        print >> sys.stderr, "Execution failed:", e

    return output
EOF

function! s:GenerateHtml(fnam)
    execute ':py executeShellCmd(r"'.g:MarkdownPath.' '.a:fnam.' > '.a:fnam.'.html")'
    return a:fnam.'.html'
endfunction

function! s:MarkdownPreview(fnam)
    let htmlFnam = s:GenerateHtml(a:fnam)
    call FirefoxPreview(htmlFnam)
endfunction

function! s:MarkdownPreviewClose(fnam)
    echo "Closing preview."
    let htmlFnam = s:GenerateHtml(a:fnam)
    call FirefoxPreview(htmlFnam)
endfunction

function! s:MarkdownPreviewTogglePreview(filetypes)
    if !exists('s:PreviewEnabled')
        let s:PreviewEnabled=0
    endif
    if s:PreviewEnabled
        let s:PreviewEnabled=0
        call s:MarkdownPreviewDisablePreviewOnSave()
    else
        let s:PreviewEnabled=1
        call s:MarkdownPreviewEnablePreviewOnSave(a:filetypes)
        call FirefoxPreviewCreateFunctions()
    endif
endfunction
command! -nargs=1 MarkdownPreviewTogglePreview call s:MarkdownPreviewTogglePreview(<f-args>)

function! s:MarkdownPreviewEnablePreviewOnSave(filetypes)
    echo "Markdown Preview on save enabled."
    let g:PreviewFileTypes=a:filetypes
    call FirefoxPreviewDisablePreviewOnSave()
    augroup MarkdownPreviewOnSave
        autocmd!
        autocmd BufEnter     * :call s:MarkdownPreview(expand('%:p'))
        autocmd BufWritePost * :call s:MarkdownPreview(expand('%:p'))
        autocmd BufDelete    * :call s:MarkdownPreviewClose(expand('<afile>:p'))
        autocmd BufWipeout   * :call s:MarkdownPreviewClose(expand('<afile>:p'))
        autocmd VimLeave     * :call s:MarkdownPreviewClose(expand('%:p'))
    augroup end
endfunction

function! s:MarkdownPreviewDisablePreviewOnSave()
    echo "Preview on save disabled."
    call FirefoxPreviewDisablePreviewOnSave()
    augroup MarkdownPreviewOnSave
        autocmd!
    augroup end
endfunction

map <buffer> <Leader>pr :MarkdownPreviewTogglePreview markdown<CR>
