# Set up the prompt
PROMPT='%n@%m:%~> '

setopt histignorealldups sharehistory
setopt ignoreeof
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS=$LS_COLORS:'di=0;36'
    alias ls='ls -hF --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls zaliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
alias h='history'

# Enable zsh-autosuggestions
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# update_spimbot.sh

Arch=$(uname -m)

DEST_PATH=/home/ubuntu/shared
BINARY_VERSION="linux_arm64"

if [ $Arch = "x86_64" ]; then
    BINARY_VERSION="linux_x86_64"
fi;

if [[ $PATH != ?(*:)$DEST_PATH?(:*) ]]; then
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
cd /home/ubuntu/shared
