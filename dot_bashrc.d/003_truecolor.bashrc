# Advertise 24-bit ("truecolor") support so programs like git-delta emit real
# 24-bit color instead of downsampling to 256 colors. Delta only emits its
# exact hex theme when COLORTERM says truecolor; without it, a plain shell
# shows an approximation while Neovim's built-in terminal (which forces
# COLORTERM=truecolor) shows the exact colors. This makes them match.
export COLORTERM=truecolor
