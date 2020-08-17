This is my vim config

`sudo pacman -S discover archlinux-appstream-data packagekit-qt5 flatpak fwupd`

`sudo npm install tslib neovim log4js socket.io msgpack-lite`


~/.vim/plugged/vimspector/

## 添加vim并共享配置为了使用完整版vimspector

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln -s ~/.local/share/nvim/site ~/.vim
ln -s .config/nvim/init.vim .vimrc
```
