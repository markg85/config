# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export MARK_CONFIGS_FOLDER=configs_git

# Path to your oh-my-zsh installation.
export ZSH=$HOME/$MARK_CONFIGS_FOLDER/oh-my-zsh

source $ZSH/plugins/

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MODE='awesome-fontconfig'

# ZSH theme
ZSH_THEME="powerlevel10k/powerlevel10k"

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

# custom folder location
ZSH_CUSTOM=$HOME/$MARK_CONFIGS_FOLDER/custom

# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-256color zsh-syntax-highlighting docker)

# User configuration

export PATH=~/kde/src/kdesrc-build:$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
export ZLS_COLORS=$LS_COLORS

# upload a file to paste.sc2.nl
function upload()
{
  curl -s -X POST -F data=@$1 --compressed https://p.sc2.nl/data
}

# paste content from pipe
function paste()
{
  curl -s -X POST -H "Content-Type: text/plain" --data-binary @- --compressed https://p.sc2.nl/api/${1:=cpp} | getJsonVal "['url']" | awk 1
}

# I don't know python!
# Source: https://stackoverflow.com/a/21595107
function getJsonVal()
{ 
  python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1).strip('\"'))";
}

# folderSize function, returns the size for each folder in the current directory.
# If used like "folderSize 10G", it will only show all folders with 10G or more.
# See du documentation for threshold.
function folderSize()
{
  THRESHOLD=""

  if [ -n "$1" ]; then
    THRESHOLD="--threshold=${1}"
  fi

  for file in */; do
    du -hs $file $THRESHOLD 2>/dev/null
  done
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

alias grep='grep --color=auto -n'
alias cppgrep='noglob grep -Rin --color=auto --include=\*.{cpp,c,h,qml,js}'
alias ff='noglob ff'
alias fif='noglob fif'
#alias ls='ls --color=always'
#alias ls='ls++'
alias kcachelatest='kcachegrind $(ls callgrind* -rt | tail -n 1)'

# Command not found for Arch Linux. Tries to find the package that contains the command.
source /usr/share/doc/pkgfile/command-not-found.zsh

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
