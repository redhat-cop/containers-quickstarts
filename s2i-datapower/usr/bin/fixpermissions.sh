#!/bin/sh
# Fix permissions on the given directory to allow group read/write of
# regular files and execute of directories.
chown -R default "$1"
#chown -h default "$1"
chgrp -R 0 "$1"
#chgrp -h 0 "$1"
chmod -R g+rw "$1"
find "$1" -type d -exec /bin/busybox chmod g+x {} +