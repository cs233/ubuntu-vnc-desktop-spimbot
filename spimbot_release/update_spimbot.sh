#!/bin/bash

set -e

Arch=$(uname -m)

DEST_PATH=/home/ubuntu/shared
BINARY_VERSION="linux_arm64"

if [ $Arch = "x86_64" ]; then
    BINARY_VERSION="linux_x86_64"
fi;

if [[ $PATH == ?(*:)$DEST_PATH?(:*) ]]; then
else
    export PATH=$DEST_PATH:$PATH
fi

cd /home/ubuntu
if [ ! -e "/home/ubuntu/.spimbot/spimbot-binaries" ]; then
    mkdir ./.spimbot/
    cd ./.spimbot/
    git clone https://github.com/cs233/spimbot-binaries
fi;

cd /home/ubuntu/.spimbot/spimbot-binaries 
git remote update > /dev/null
commitdiff=$(git rev-list HEAD...origin/main --count)

if [ ! -e "/home/ubuntu/shared/QtSpimbot" ] || [ $commitdiff -gt 0 ]; then
    echo "Update required, pulling + installing..."
    git checkout main > /dev/null && git pull > /dev/null
    cp "/home/ubuntu/.spimbot/spimbot-binaries/$BINARY_VERSION/QtSpimbot" "/home/ubuntu/shared"
    echo "Installed new binary"
fi;

cp /home/ubuntu/.spimbot/spimbot-binaries/$BINARY_VERSION/QtSpimbot $DEST_PATH
echo "Installed new binary"
cd ~/shared
