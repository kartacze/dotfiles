 
# initial setup
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
ubuntu-drivers devices
sudo ubuntu-drivers autoinstall
sudo apt install -y curl python-pip fd-find git tmux silversearcher-ag

# alacritty
add-apt-repository ppa:mmstick76/alacritty
sudo apt install alacritty

# neovim - this should be build by hand
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage

  # vim-plug install
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall

# nvm install
curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash
source ~/.bashrc
eval "`fnm env --multi`"
fnm install

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install --no-install-recommends yarn
  # to use globally installed packages
echo 'export PATH="$(yarn global bin):$PATH"' >> ~/.bashrc

# git
sudo apt install git
yarn global add diff-so-fancy
