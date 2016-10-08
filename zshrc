export MARK_CONFIGS_FOLDER=configs_git

# Path to your oh-my-zsh installation.
export ZSH=$HOME/$MARK_CONFIGS_FOLDER/oh-my-zsh

source $ZSH/plugins/

# ZSH theme
ZSH_THEME="bureau"

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
plugins=(git zsh-256color zsh-syntax-highlighting)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
export ZLS_COLORS=$LS_COLORS

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
