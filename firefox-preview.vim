if exists('s:Sourced')
    finish
else
    let s:Sourced=1
endif

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

function! s:FirefoxPreview(fnam)
    if exists ('g:PreviewFileTypes') && &ft =~ g:PreviewFileTypes
        execute ':py preview(r"'.a:fnam.'")'
    endif
endfunction

function! s:FirefoxPreviewClose(fnam)
    if exists ('g:PreviewFileTypes') && &ft =~ g:PreviewFileTypes
        echo "Closing preview."
        execute ':py close(r"'.a:fnam.'")'
    endif
    return
endfunction

function! s:TogglePreview(filetypes)
    if !exists('s:PreviewEnabled')
        let s:PreviewEnabled=0
    endif
    if s:PreviewEnabled
        let s:PreviewEnabled=0
        call s:DisablePreviewOnSave()
    else
        let s:PreviewEnabled=1
        call s:EnablePreviewOnSave(a:filetypes)
        execute ':py createFunctions()'
    endif
endfunction
command! -nargs=1 TogglePreview call s:TogglePreview(<f-args>)

function! s:EnablePreviewOnSave(filetypes)
    echo "Preview on save enabled."
    let g:PreviewFileTypes=a:filetypes
    augroup FirefoxPreviewOnSave
        autocmd BufEnter     * :call s:FirefoxPreview(expand('%:p'))
        autocmd BufWritePost * :call s:FirefoxPreview(expand('%:p'))
        autocmd BufDelete    * :call s:FirefoxPreviewClose(expand('<afile>:p'))
        autocmd BufWipeout   * :call s:FirefoxPreviewClose(expand('<afile>:p'))
        autocmd VimLeave     * :call s:FirefoxPreviewClose(expand('%:p'))
    augroup end
endfunction

function! s:DisablePreviewOnSave()
    echo "Preview on save disabled."
    augroup FirefoxPreviewOnSave
        autocmd!
    augroup end
endfunction
