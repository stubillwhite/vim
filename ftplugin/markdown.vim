let g:MarkdownPath=g:Home.'/utils/bin/Markdown/Markdown.pl'

python << EOF
import os
import subprocess
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

def createFunctions():
    # Taken from https://developer.mozilla.org/en-US/docs/Code_snippets/Tabbed_browser
    cmd = '''
             ;
             function openAndReuseOneTabPerURL(url) {
               var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
                                  .getService(Components.interfaces.nsIWindowMediator);
               var browserEnumerator = wm.getEnumerator("navigator:browser");
              
               // Check each browser instance for our URL
               var found = false;
               while (!found && browserEnumerator.hasMoreElements()) {
                 var browserWin = browserEnumerator.getNext();
                 var tabbrowser = browserWin.gBrowser;
              
                 // Check each tab of this browser instance
                 var numTabs = tabbrowser.browsers.length;
                 for (var index = 0; index < numTabs; index++) {
                   var currentBrowser = tabbrowser.getBrowserAtIndex(index);
                   if (url == currentBrowser.currentURI.spec) {
              
                     // The URL is already opened. Select this tab.
                     tabbrowser.selectedTab = tabbrowser.tabContainer.childNodes[index];
              
                     // Focus *this* browser-window
                     browserWin.focus();
              
                     found = true;
                     break;
                   }
                 }
               }
              
               // Our URL isn't open. Open it now.
               if (!found) {
                 var recentWindow = wm.getMostRecentWindow("navigator:browser");
                 if (recentWindow) {
                   // Use an existing browser window
                   recentWindow.delayedOpenTab(url, null, null, null, null);
                 }
                 else {
                   // No browser windows are open, so open a new one.
                   window.open(url);
                 }
               }
             };
             repl.quit();
          '''
    executeCmd(cmd)

def close(fnam):
    uri = getUri(fnam)
    cmd = ''' 
            ;
            openAndReuseOneTabPerURL("%(uri)s");
            gBrowser.removeCurrentTab();
            repl.quit();
         '''
    executeCmd(cmd % { 'uri' : uri})

def preview(fnam):
    uri = getUri(fnam)
    cmd = ''' 
            ;
            openAndReuseOneTabPerURL("%(uri)s");
            vimYo = content.window.pageYOffset; 
            vimXo = content.window.pageXOffset; 
            BrowserReload();
            content.window.scrollTo(vimXo,vimYo);
            repl.quit();
         '''
    executeCmd(cmd % { 'uri' : uri})

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
        execute ':py createFunctions()'
    endif
endfunction
command! -nargs=0 TogglePreview call s:TogglePreview()

function! s:EnablePreviewOnSave()
    echo "Preview on save enabled."
    augroup MarkdownPreviewOnSave
        autocmd BufEnter     *.md :call s:MarkdownPreview(expand('%:p'))
        autocmd BufWritePost *.md :call s:MarkdownPreview(expand('%:p'))
        autocmd BufDelete    *.md :call s:MarkdownPreviewClose(expand('<afile>:p'))
        autocmd BufWipeout   *.md :call s:MarkdownPreviewClose(expand('<afile>:p'))
        autocmd VimLeave     *.md :call s:MarkdownPreviewClose(expand('%:p'))
    augroup end
endfunction

function! s:DisablePreviewOnSave()
    echo "Preview on save disabled."
    augroup MarkdownPreviewOnSave
        autocmd!
    augroup end
endfunction

nnoremap <Leader>pr :TogglePreview<CR>
