let g:MarkdownPath=g:Home.'/utils/bin/Markdown/Markdown.pl'

python << EOF
import os
import telnetlib
import urllib
import vim

def executeCmd(cmd):
    repl = telnetlib.Telnet('localhost', 4242)
    repl.read_until('repl', 3000)
    repl.read_until('>', 3000)
    repl.write(cmd)
    repl.close()

def getUri(fnam):
    drive, path = os.path.splitdrive(fnam)
    path = path.replace('\\', '/')
    uri = 'file:///%s%s' % (drive, path)
    return uri

def close(fnam):
    uri = getUri(fnam)
    cmd = ''' 
            ;
            if (switchToTabHavingURI("%(uri)s")) { 
                gBrowser.removeCurrentTab();
            };
            repl.quit();
         '''
    executeCmd(cmd % { 'uri' : uri})

def preview(fnam):
    uri = getUri(fnam)
    cmd = ''' 
            ;
            if (!switchToTabHavingURI("%(uri)s")) { 
                gBrowser.selectedTab = gBrowser.addTab("%(uri)s"); 
            }
            else
            {
                vimYo = content.window.pageYOffset; 
                vimXo = content.window.pageXOffset; 
                gBrowser.reload();
                content.window.scrollTo(vimXo,vimYo);
            };
            repl.quit();
         '''
    executeCmd(cmd % { 'uri' : uri})
EOF

function! s:GenerateHtml(fnam)
    silent! execute '!'.g:MarkdownPath.' '.a:fnam.' > '.a:fnam.'.html'
    return a:fnam.'.html'
endfunction

function! s:MarkdownPreview(fnam)
    let htmlFnam = s:GenerateHtml(a:fnam)
    execute ':py preview(r"'.htmlFnam.'")'
endfunction

function! s:MarkdownPreviewClose(fnam)
    echo "Closing preview."
    let htmlFnam = s:GenerateHtml(a:fnam)
    execute ':py close(r"'.htmlFnam.'")'
endfunction

function! s:TogglePreview()
    if !exists('s:PreviewEnabled')
        let s:PreviewEnabled=0
    endif
    if s:PreviewEnabled
        let s:PreviewEnabled=0
        call s:DisablePreviewOnSave()
    else
        let s:PreviewEnabled=1
        call s:EnablePreviewOnSave()
    endif
endfunction
command! -nargs=0 TogglePreview call s:TogglePreview()

function! s:EnablePreviewOnSave()
    echo "Preview on save enabled."
    augroup MarkdownPreviewOnSave
        autocmd BufEnter     *.mkd :call s:MarkdownPreview(expand('%:p'))
        autocmd BufWritePost *.mkd :call s:MarkdownPreview(expand('%:p'))
        autocmd BufDelete    *.mkd :call s:MarkdownPreviewClose(expand('<afile>:p'))
        autocmd BufWipeout   *.mkd :call s:MarkdownPreviewClose(expand('<afile>:p'))
        autocmd VimLeave     *.mkd :call s:MarkdownPreviewClose(expand('%:p'))
    augroup end
endfunction

function! s:DisablePreviewOnSave()
    echo "Preview on save disabled."
    augroup MarkdownPreviewOnSave
        autocmd!
    augroup end
endfunction

nnoremap <Leader>r :TogglePreview<CR>
