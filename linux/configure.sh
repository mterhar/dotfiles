#!/usr/bin/env bash

if [ -f "~/.fzf" ] 
then
  echo "fzf already present." 
else
  cp -rf ${DOTFILES_DIR}/.fzf ~/.fzf
  ~/.fzf/install --all
fi

if [ -z "$CODER_ASSETS_ROOT" ]; then
  echo "no coder, no extensions"
else
  echo "insalling gitlens"
  ${CODER_ASSETS_ROOT}/code-server/bin/code-server --install-extension ${DOTFILES_DIR}/extensions/eamodio.gitlens-11.7.0.vsix
fi

