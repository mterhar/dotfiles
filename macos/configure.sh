#!/usr/bin/env bash

echo "Disabling smart keyboard stuff"
# Disable smart quotes 
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable smart dashes 
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Enable tabs to hit all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "configuring finder"
## FINDER
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES
# Show all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show bars and paths
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable extension change warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
