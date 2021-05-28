# Rebind Ctrl-a as the prefix
unbind-key -n C-a
set -g prefix ^A
set -g prefix2 F12

# Reloads the config file
bind r source-file ~/.byobu/keybindings.tmux \; display "Config reloaded!"

# Unbind Meta-left and Meta-right keys since they're more often
# used for quickly jumping between words on the terminal.
unbind-key -n M-Left
unbind-key -n M-Right

# Press <prefix> and then 'a' to send Ctrl-a to the application
bind a send-prefix

# Send prefix to an application by pressing the prefix twice
bind C-a send-prefix

# synchronize-panes shortcut
bind y set-window-option synchronize-panes

# Window splitting
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
#
# BEGIN Adapted from https://stackoverflow.com/a/40902312
#
run-shell 'tmux setenv -g TMUX_VERSION $(tmux -V | sed -E "s/^tmux +([\.0-9]+).*/\1/g")'
# NOTE: tmux doesn't use SemVer. It just increments by 0.1 with every release.
if-shell -b '[ "$(echo "$TMUX_VERSION <  2.9" | bc)" = 1 ]' ' \
    bind-key \ split-window -h -c "#{pane_current_path}"'

if-shell -b '[ "$(echo "$TMUX_VERSION >= 2.9" | bc)" = 1 ]' ' \
    bind \\ split-window -h -c "#{pane_current_path}"'
#
# END
#

# These bindings allow you to stay in your keyboard's home
# row when moving between panes. Assuming, of course, that
# you've swapped your Ctrl and Caps Lock keys which you should!
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes using the home row too!
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Make copy/paste same as vim
bind Escape copy-mode
unbind p
bind p paste-buffer
unbind-key -T copy-mode-vi v
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel

set -g status-left "#[fg=colour248]S:#S  W:#I  P:#P#{?pane_synchronized, #[fg=colour255]#[bg=red](panes are synced. 'Ctrl-A y' to toggle)#[default],} "
