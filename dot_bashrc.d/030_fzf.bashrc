# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.config/fzf-completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.config/fzf-key-bindings.bash"

export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git --exclude node_modules --exclude *.pyc --exclude .venv --exclude .devbox --exclude .terragrunt-cache --exclude .worktrees --no-ignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--multi --layout=reverse --border --info=inline --color=16 --height=~80% --preview-window right:60% --preview "bat --style=full --color=always --line-range :500 {}" --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down'
