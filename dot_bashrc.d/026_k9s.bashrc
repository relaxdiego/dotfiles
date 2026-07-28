# vi: ft=bash

# Use the kanagawa-dragon skin, matching the Neovim colorscheme.
# The skin file is ~/.config/k9s/skins/kanagawa-dragon.yaml. This env var is
# used instead of the `ui.skin` key in config.yaml because k9s rewrites
# config.yaml itself, which would fight with chezmoi.
export K9S_SKIN=kanagawa-dragon
