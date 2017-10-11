#!/bin/sh
echo "Launching Meld: $1 vs $2"

# http://www.wiredforcode.com/blog/2011/06/04/git-with-meld-diff-viewer-on-ubuntu/
meld "$2" "$5" > /dev/null 2>&1
