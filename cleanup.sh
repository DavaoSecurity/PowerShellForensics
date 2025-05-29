#!/bin/bash
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
#
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y

sudo journalctl --vacuum-time=90d
# sudo journalctl --vacuum-size=500M

rm -rf ~/.cache/thumbnails/*

# sudo apt install deborphan
deborphan
sudo apt-get remove --purge $(deborphan)