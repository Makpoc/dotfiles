#!/bin/bash

if [ -z $1 ]; then
    echo "usage: `basename $0` youtube_link"
    exit 1
fi

mpc add `youtube-dl -f bestaudio -ig $1`

exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "Successfully added $1 to mpd playlist"
else
    echo "Adding song $1 failed! exit code: $exit_code"
    exit $exit_code
fi

mpc play
