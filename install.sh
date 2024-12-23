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
git config --file ~/.gitconfig.local user.email "mike@terhar.com"

if [ -f "~/.fzf" ]
then
  echo "fzf already present."
else
  cp -rf ${DOTFILES_DIR}/.fzf ~/.fzf
  ~/.fzf/install --all
fi

mkdir -p ~/.vim_backup
