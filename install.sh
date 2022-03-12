#!/usr/bin/env bash
DOTFILES_DIR=$(pwd)
builddt=$(date +"%Y%m%d-%H%M%S")

case "$OSTYPE" in
  solaris*) echo "SOLARIS" ;;
  darwin*)  
    echo "MacOS"
    . $DOTFILES_DIR/macos/configure.sh
    ;;
  linux*)   
    echo "LINUX"
    . $DOTFILES_DIR/linux/configure.sh
    ;;
  bsd*)     echo "BSD" ;;
  msys*)    echo "WINDOWS" ;;
  cygwin*)  echo "ALSO WINDOWS" ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

if [ -f "~/.local/share/code-server/User/settings.json" ] 
then
  echo "VS Code settings are already present." 
else
  cp -rf ${DOTFILES_DIR}/.local ~/.local
fi

cp -rf ${DOTFILES_DIR}/.fonts ~/.fonts
cp -f ${DOTFILES_DIR}/.gitconfig ~/.gitconfig
cp -f ${DOTFILES_DIR}/.vimrc ~/.vimrc
cp -f ${DOTFILES_DIR}/.zshrc ~/.zshrc
cp -f ${DOTFILES_DIR}/.bashrc ~/.bashrc

git config --file ~/.gitconfig.local user.name "Mike Terhar"
git config --file ~/.gitconfig.local user.email "mike@coder.com"

if [ -f "~/.fzf" ]
then
  echo "fzf already present."
else
  cp -rf ${DOTFILES_DIR}/.fzf ~/.fzf
  ~/.fzf/install --all
fi

mkdir -p ~/.vim_backup

echo "need a new gpg key before re-enabling this."

exit 0 
if hash gpg 2>/dev/null; then
  mkdir -p ~/.gnupg
  chmod 700 ~/.gnupg
  echo "gpg found, configuring public key and matching git credentials"
  gpg --import ${DOTFILES_DIR}/.gnupg/mike_coder.com-publickey.asc
  echo "7E8272805E6921642AA3A2A0F21DA83779444E18:6:" | gpg --import-ownertrust
  git config --file ~/.gitconfig.local user.signingkey F21DA83779444E18
  # git config --file ~/.gitconfig.local commit.gpgsign true
  mv -n ~/.gnupg/gpg.conf ~/.gnupg/gpg.conf.${builddt}.bak
  mv -n ~/.profile ~/.profile.${builddt}.bak
  echo "pinentry-mode loopback" > ~/.gnupg/gpg.conf
  echo "export GPG_TTY=\$(tty)" > ~/.profile
else
  echo "gpg not found, no git signing"
fi
