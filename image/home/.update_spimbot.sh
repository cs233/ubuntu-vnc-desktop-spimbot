# Update the spimbot binary if it's not present or if there's a new version

Arch=$(uname -m)

WORKING_FOLDER=/home/ubuntu/shared
BINARY_VERSION="linux_arm64"

if [ $Arch = "x86_64" ]; then
    BINARY_VERSION="linux_x86_64"
fi;

export PATH=$WORKING_FOLDER:$PATH      # Add the students' working directory

cd /home/ubuntu
if [ ! -e "/home/ubuntu/.spimbot/spimbot-binaries" ]; then
    mkdir ./.spimbot/
    cd ./.spimbot/
    git clone https://github.com/cs233/spimbot-binaries
fi;

cd /home/ubuntu/.spimbot/spimbot-binaries
git remote update > /dev/null
commitdiff=$(git rev-list HEAD...origin/main --count)

if [ ! -e $WORKING_FOLDER/QtSpimbot ] || [ $commitdiff -gt 0 ]; then
    echo "Update required, pulling + installing..."
    git checkout main > /dev/null && git pull > /dev/null
    echo "Installed new binary"
fi;

cp /home/ubuntu/.spimbot/spimbot-binaries/$BINARY_VERSION/QtSpimbot $WORKING_FOLDER

echo "QtSpimbot updated"
cd $WORKING_FOLDER