#!/usr/bin/env bash

if [ -z "$CODER_ASSETS_ROOT" ]; then
  echo "no coder, no extensions"
else
  echo "insalling gitlens"
  ${CODER_ASSETS_ROOT}/code-server/bin/code-server --install-extension ${DOTFILES_DIR}/extensions/eamodio.gitlens-11.7.0.vsix
fi

