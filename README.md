## Configs

## Installation
1. Clone this repository anywhere you want.
2. git submodule init
3. git submodule update --depth 1 --remote
4. in your home folder, link ".zshrc" to your cloned path/zshrc `ln -s configs_git/zshrc .zshrc`
5. edit ~/.zshrc (which is the same file as "zshrc in your cloned path) and adjust the MARK_CONFIGS_FOLDER define accordingly. Note that this folder is relative to your home 
folder!
6. Change the shell to ZSH `chsh -s /bin/zsh`

## Install gitconfig
1. open your `~/.gitconfig`
2. Add the following:
```
[include]
    path = <path_to_this_repo_clone>/gitconifg
```

## Install MPV configs
1. Remove (or rename) your ~/.config/mpv folder
2. link the mpv folder to ~/.config/mpv

## Install NVIM configs
1. Remove (or rename) your ~/.config/nvim folder
2. Link the nvim folder to ~/.config/nvim
3. Run nvim and type ":PlugInstall" to install all the plugins.
 
To update the plugins, type ":PlugUpdate" or refer to the "vim-plug" documentation.

All custom plugins/themes/whatever are in the clone/custom folder.
