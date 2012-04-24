#!/bin/sh

# This should probably be rock built-in functionality, someday.
# But this will work great with rock 0.9.4
DEPS=`grep "Depends: " establichment.use | sed 's/Depends: //g' | xargs echo`

mkdir -p libs
cd libs

for i in $DEPS; do
    git clone $i
done
