# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export MARK_CONFIGS_FOLDER=configs_git

# Path to your oh-my-zsh installation.
export ZSH=$HOME/$MARK_CONFIGS_FOLDER/oh-my-zsh

# Set COLORTERM, makes some apps output nice colors (like ls), might already be set
export COLORTERM=truecolor

source $ZSH/plugins/

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MODE='awesome-fontconfig'


source $HOME/$MARK_CONFIGS_FOLDER/custom/zsh_theme_handler.sh
# ZSH theme
# ZSH_THEME=
#ZSH_THEME=linuxonly
#ZSH_THEME=agnoster
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Magic function (paste) is garbage!
DISABLE_MAGIC_FUNCTIONS="true"

# custom folder location
ZSH_CUSTOM=$HOME/$MARK_CONFIGS_FOLDER/custom

# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-256color zsh-syntax-highlighting docker)

# User configuration

export PATH=~/kde/src/kdesrc-build:$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
export ZLS_COLORS=$LS_COLORS

function folderSize()
{
    $HOME/$MARK_CONFIGS_FOLDER/custom/folderSize.sh "$@"
}

# upload a file to paste.sc2.nl
function upload()
{
  # Capture the URL from the curl command into a variable
  url=$(curl -s -X POST -F data=@"${1:--}" --compressed https://p.sc2.nl/data -w "\n")

  # Print the URL to the terminal
  echo "URL: ${url}"

  # Check if qrencode is installed
  if command -v qrencode &> /dev/null; then
    # Generate and display the QR code in the terminal
    qrencode -t UTF8 "${url}"
  else
    echo "qrencode is not installed. Please install it to generate QR codes."
  fi
}

# paste content from pipe
function paste()
{
  URLPART=""
  if [ "$#" -lt 2 ]; then
    URLPART=${1:=cpp}
  elif [ "$#" -lt 3 ]; then
    URLPART=${1:=}/${2:=cpp}
  fi

  curl -s -X POST -H "Content-Type: text/plain" --data-binary @- --compressed https://p.sc2.nl/api/${URLPART} | getJsonVal "['url']" | awk 1
}

# I don't know python!
# Source: https://stackoverflow.com/a/21595107
function getJsonVal()
{ 
  python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1).strip('\"'))";
}

# find files
# example: ff "*.cpp"
function ff()
{
    find . -iname "$1" 2>/dev/null
}

# find files in folder
# example: fif "main.*" "*return*"
# example: fif "*return*" // It will try to find that string in all the files under your current folder (excluding .svn and .git).
function fif()
{
    if [ $# -eq 2 ]
      then
        find . -type d '(' -name .svn -o -name .git ')' -prune -o -type f -iname "$1" -exec grep -Hin --color=auto "$2" {} \;
    else
      find . -type d '(' -name .svn -o -name .git ')' -prune -o -type f -exec grep -Hin --color=auto "$1" {} \;
    fi
}

# mediaserver play
function msp()
{
    node --no-warnings=ExperimentalWarning ~/GitProjects/mediaserveripfs/index.js play "$1" --dump ~/dump.json --private-key ~/.ssh/x25519-priv-mark.pem
#    node --no-warnings=ExperimentalWarning ~/GitProjects/mediaserveripfs/index.js play "$1" --dump ~/dump.json --public-key ~/.ssh/x25519-pub-seedbox.pem --private-key ~/.ssh/x25519-priv-mark.pem
}

function mediaserver()
{
    node --no-warnings=ExperimentalWarning ~/GitProjects/mediaserveripfs/index.js $@ --dump ~/dump.json --private-key ~/.ssh/x25519-priv-mark.pem
#    node --no-warnings=ExperimentalWarning ~/GitProjects/mediaserveripfs/index.js $@ --dump ~/dump.json
}

function mse()
{
    COMMAND=$(node /home/mark/GitProjects/mediaserveripfs/index.js "$1" QmPBKKQ5pQSqZixe1YaUpb5DEJRfAXFmpUVW9vZ9KE7czP)
    if [[ $COMMAND ]]; then
        mpv_decrypt_args $COMMAND
    else
        echo ""
    fi
}


function ipfs_save()
{
    ipfs get $1 -o $1
}

alias grep='grep --color=auto -n'
alias yay='yay --combinedupgrade'
alias cppgrep='noglob grep -Rin --color=auto --include=\*.{cpp,c,cc,cxx,h,qml,js}'
alias ff='noglob ff'
alias fif='noglob fif'
#alias ls='ls --color=always'
#alias ls='ls++'
alias kcachelatest='kcachegrind $(ls callgrind* -rt | tail -n 1)'
alias ip='ip -c'

# alias for file encryption
alias encrypt_aes='bash ~/$MARK_CONFIGS_FOLDER/custom/encrypt_aes.sh'

# alias for a simple jq wrapper to simplify jq usage
alias jqw='bash ~/$MARK_CONFIGS_FOLDER/custom/jqw.sh'

# alias to help with mpv decrypt arguments.
alias mpv_decrypt_args='bash ~/$MARK_CONFIGS_FOLDER/custom/mpv_decrypt_args.sh'

# Command not found for Arch Linux. Tries to find the package that contains the command.
[[ ! -f /usr/share/doc/pkgfile/command-not-found.zsh ]] || source /usr/share/doc/pkgfile/command-not-found.zsh

# highlight the typed text in tab completion.
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")'; 

# rich ls highlighting
# eval $(dircolors -b $HOME/.dircolors)

# History search. Binds UP and DOWN keys.
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Automatically rehash
zstyle ':completion:*' rehash true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/$MARK_CONFIGS_FOLDER/p10k.zsh ]] || source $HOME/$MARK_CONFIGS_FOLDER/p10k.zsh
