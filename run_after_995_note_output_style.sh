#!/bin/bash -e

# Notice when Claude Code's output style changes, and leave a note for the
# closing banner (run_after_final_home_is_where_the_heart_is.sh.tmpl) to print
# inside its box. The tab matters: the banner splits on it and lines the two
# halves up.
#
# Not a run_onchange_ script, unlike the tmux and Ghostty reminders next to it.
# Those fire when the source text changes, which here would miss the case that
# matters most: `/output-style` inside Claude Code writes settings.json, and
# the next apply silently puts it back. So this compares the state on disk
# against a stamp from the previous apply and reports what actually moved.
#
# It runs in the "after" phase, so settings.json and the style file are both
# already written, and it sorts ahead of "final" so the banner sees the note.

SETTINGS="$HOME/.claude/settings.json"
STAMP="${XDG_STATE_HOME:-$HOME/.local/state}/chezmoi/claude-output-style"
NOTES="${TMPDIR:-/tmp}/chezmoi-apply-notes.$(id -u)"

sha256() {  # <path>; prints "missing" when there is nothing to hash
    if [ ! -f "$1" ]; then
        echo missing
    elif command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | cut -d' ' -f1
    else
        shasum -a 256 "$1" | cut -d' ' -f1
    fi
}

# An unset outputStyle is Claude Code's built-in default, which has no file.
style=default
if [ -f "$SETTINGS" ] && command -v jq >/dev/null 2>&1; then
    style="$(jq -r '.outputStyle // "default"' "$SETTINGS" 2>/dev/null)" || style=default
fi

now="$style $(sha256 "$HOME/.claude/output-styles/$style.md")"
was=""
if [ -f "$STAMP" ]; then
    was="$(cat "$STAMP")"
fi

if [ "$now" != "$was" ]; then
    # Same name, different bytes: the style itself was rewritten under us.
    if [ "${was%% *}" = "$style" ]; then
        what="$style output style changed"
    else
        what="output style is now $style"
    fi
    # Only a new session reads it: the style is part of the system prompt,
    # which is built once when Claude Code starts.
    printf '%s\tstart a new Claude session\n' "$what" >> "$NOTES"

    mkdir -p "$(dirname "$STAMP")"
    printf '%s\n' "$now" > "$STAMP"
fi
