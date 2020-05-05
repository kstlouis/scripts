#!/bin/bash

# script to search through a directory for movie files that are not hardlinked anywhere else.
# meaning they may/may not be in your DL client, but they aren't seen by Sonarr/Radarr.
# useful if you want to clean up your downloads. 
# sometimes a torrent client won't delete the torrent data when requested; 
#maybe a bug, or permissions issue. Either way, gets left behind and takes up drive space. 

# will accept multiple directories as arguments

if [[ $# -lt 1 ]] ; then
    echo "Usage: findhardlinks <fileOrDirToFindFor> ..."
    exit 1
fi

while [[ $# -ge 1 ]] ; do # if # arguments greater than 1
    echo "Processing '$1' : "
    if [[ ! -r "$1" ]] ; then
        echo "   '$1' is not accessible"
    else
	cd $1
	find . -type f -name '*.mkv' ! -path "./torrentfiles/*" -links 1 -exec du -h '{}' + | sort -hr
    fi
    shift # move to next dir, if given
done

# notes:
# only finds mkv's because plenty of sub/metadata/etc files dont' get linked
# if any of your missing items are .rar's, they could get missed
# extraction-in-place and deletion of entire directory probably covers this case. 
# sizes in human-readable format, 
