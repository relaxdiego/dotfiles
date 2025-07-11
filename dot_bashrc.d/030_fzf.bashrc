# Auto-completion
# ---------------
# Commented out since it's conflicting with bash-completion@2
# [[ $- == *i* ]] && source "$HOME/.config/fzf-completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.config/fzf-key-bindings.bash"

export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git --exclude .mypy_cache --exclude node_modules --exclude *.pyc --exclude .venv --exclude .devbox --exclude .terragrunt-cache --exclude .worktrees --no-ignore'
export FZF_DEFAULT_OPTS='--multi --layout=reverse --border --info=inline --color=16 --height=~80%'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview-window bottom:50% --preview "bat --style=full --color=always --line-range :500 {} 2>/dev/null || echo Preview not available for object." --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down'
