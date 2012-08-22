python << EOF
import os
import re
import subprocess

def matches(s, patterns):
    for p in patterns:
        if p.match(s):
            return True
    return False

def find(include, exclude, cdepth=3, pdepth=1):

    inc_patterns = [re.compile(r) for r in include]
    exc_patterns = [re.compile(r) for r in exclude]

    cwd = os.getcwd()

    maxdepth = cwd.count(os.path.sep) + cdepth
    rootpath = cwd + (os.path.sep + '..') * pdepth

    matching_files = []
    for dirpath, dirnames, filenames in os.walk(rootpath, topdown=True):

        currpath = os.path.normpath(dirpath)
        if currpath.count(os.path.sep) > maxdepth:
            del dirnames[:]
        else:
            for f in filenames:
                fullpath = os.path.join(currpath, f)
                if matches(fullpath, inc_patterns) and not matches(fullpath, exc_patterns):
                    print ' ', fullpath
                    matching_files.append(fullpath)

    return matching_files

INCLUDE = ['.*' + re.escape(os.path.sep + r) for r in [
                r'accurev_ignore_targets.xml',
                r'apollo-examples.xml',
                r'apollo-jboss-deployment-internal.xml',
                r'apollo-jboss-deployment.xml',
                r'apollo-tomcat-deployment-internal.xml',
                r'apollo-tomcat-deployment.xml',
                r'build.xml',
                r'common-build-utils.xml',
                r'ComponentCommon.xml',
                r'database-build-scripts.xml',
                r'deployment-utils.xml',
                r'filesystem_utils.xml',
                r'generic_build_targets.xml',
                r'JUnitReport_build_targets.xml',
                r'ProjectBuild.xml',
                r'webui-build-utils.xml',
                r'configure-was-read-side.xml',
                r'deploy-read-side-application.xml',
                r'manage-read-server.xml',
                r'pack-read-side-ear.xml',
                r'unpack-read-side-ear.xml',
                r'configure-was-web-help.xml',
                r'deploy-web-help.xml',
                r'manage-help-server.xml',
                r'repackage-web-help.xml',
                r'configure-was-write-side.xml',
                r'deploy-write-side-application.xml',
                r'manage-write-server.xml',
                r'pack-write-side-ear.xml',
                r'unpack-write-side-ear.xml',
                r'ear-manipulation.xml',
                r'was-config-utils.xml']]

EXCLUDE = [r'.*\.beforejunction']

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

function MakeTags()
python << EOF
print 'Finding files...'
files = find(include=INCLUDE, exclude=EXCLUDE, cdepth=7, pdepth=1)
cmd = 'ctags.exe --language-force=ant ' + ' '.join(['"%s"' % f for f in files])
print cmd
getCmdOutput(cmd)
EOF
endfunction
command -nargs=0 MakeTags call MakeTags()
