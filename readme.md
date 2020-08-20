# Prepare




~/.vim/plugged/vimspector/

## For complete vimspector experience

```PowerShell
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln -s ~/.local/share/nvim/site ~/.vim
ln -s .config/nvim/init.vim .vimrc
```

## Shell settings

### Discover

`sudo pacman -S discover archlinux-appstream-data packagekit-qt5 flatpak fwupd`

### MarkdownPreview

`sudo npm install tslib neovim log4js socket.io msgpack-lite`

### Ranger

```PowerShell
set -g -x RANGER_LOAD_DEFAULT_RC FALSE
```

### ruby

```PowerShell
set PATH /home/wgc/.gem/ruby/2.7.0/bin $PATH
```

### fzf

```PowerShell
# Defined in - @ line 1
function fzf --description alias\ fzf\ fzf\ --preview\ \'head\ -100\ \{\}\'\n
	command fzf --preview 'head -100 {}'  $argv;
end

export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border --preview-window=right'
export FZF_DEFAULT_COMMAND='fd --hidden --follow -E ".git" -E "node_modules"'
```

### omnisharp(unity)

```PowerShell
sudo pacman -S mono dotnet-host dotnet-runtime dotnet-sdk
```

