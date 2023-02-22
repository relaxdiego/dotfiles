# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.config/fzf-completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.config/fzf-key-bindings.bash"

export FZF_DEFAULT_OPTS='--multi --layout=reverse --border --info=inline --color=16 --height=40%'
