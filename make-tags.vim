python << EOF
import os
import re
import subprocess

def matches(s, patterns):
    for p in patterns:
        if p.search(s):
            return True
    return False

def find(root='.', inc_dirs=['.*'], exc_dirs=[], inc_files=['.*'], exc_files=[], depth=5):

    inc_dirs_patterns  = [re.compile(r, re.IGNORECASE) for r in inc_dirs]
    exc_dirs_patterns  = [re.compile(r, re.IGNORECASE) for r in exc_dirs]
    inc_files_patterns = [re.compile(r, re.IGNORECASE) for r in inc_files]
    exc_files_patterns = [re.compile(r, re.IGNORECASE) for r in exc_files]

    maxdepth = root.count(os.path.sep) + depth

    matching_files = []
    for dirpath, dirnames, filenames in os.walk(root, topdown=True):
        currpath = os.path.normpath(dirpath)
        if currpath.count(os.path.sep) > maxdepth or matches(dirpath, exc_dirs_patterns):
            del dirnames[:]
        else:
            for f in filenames:
                fullpath = os.path.normpath(os.path.join(dirpath, f))

                if matches(fullpath, inc_files_patterns) and matches(fullpath, inc_dirs_patterns) and not matches(fullpath, exc_files_patterns):
                    print ' ', fullpath
                    matching_files.append(fullpath)

    return matching_files

INCLUDE_DIRS = [
    r'dependencies\\ApolloConfiguration\\Servers\\WebSphere\\gar\\wsadmin',
    r'dependencies\\ApolloConfiguration\\Servers\\WebSphere\\gar\\read-side',
    r'dependencies\\ApolloConfiguration\\Servers\\WebSphere\\gar\\write-side',
    r'dependencies\\ApolloConfiguration\\Servers\\WebSphere\\gar\\webapp',
    r'dependencies\\ApolloConfiguration\\Servers\\WebSphere\\gar\\webhelp',
    r'Fetched\\i2Components\\Java Shared Build Scripts'
    ]
INCLUDE_FILES = [
    r'build.xml',
    r'common-build-utils.xml',
    r'ComponentCommon.xml',
    r'database-build-scripts.xml',
    r'deployment-utils.xml',
    r'filesystem_utils.xml',
    r'Fetched\\i2Components\\Java Shared Build Scripts\\.*\.xml',
    r'dependencies\\ApolloTomcatDeployment\\apollo-tomcat-deployment.*\.xml',
    r'dependencies\\ApolloExamples\\ant\\.*\.xml',
    r'dependencies\\ApolloConfiguration\\Servers\\WebSphere\\gar\\.*\\.*\.xml'
    ]
EXCLUDE_DIRS = [
    r'bin',
    r'bld',
    r'src',
    r'testsrc',
    r'dist',
    r'\.beforejunction']
EXCLUDE_FILES = []

def getCmdOutput(cmd, dir=None):
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

function! MakeTags()
python << EOF
print 'Finding files...'
root = os.path.join(os.getcwd(), '..')
inc_dirs = INCLUDE_DIRS + [re.escape(os.getcwd())]
files = find(root=root, inc_dirs=inc_dirs, exc_dirs=EXCLUDE_DIRS, inc_files=INCLUDE_FILES, exc_files=EXCLUDE_FILES, depth=7)
cmd = 'ctags.exe --language-force=ant ' + ' '.join(['"%s"' % f for f in files])
print 'Building tags...'
getCmdOutput(cmd)
EOF
endfunction
command! -nargs=0 MakeTags call MakeTags()
