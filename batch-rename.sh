#!/bin/bash
# renames all the files in the current directory to 0000.png, 0001.png, etc.
# use with caution
for D in *; do
    cd "$D"
    I=0
    for F in *; do
        echo "$F" `printf %04d.png $I`
        mv "$F" `printf %04d.png $I` 2>/dev/null || true
        I=$((I + 1))
    done
    cd ..
done
