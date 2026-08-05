#!/bin/bash -e

# The closing banner for `chezmoi apply`. It runs last (after_ + a name that
# sorts past the numbered scripts) so it can collect the reminders that the
# run_onchange_ scripts leave in NOTES and show them inside the same banner.

WIDTH=62
NOTES="${TMPDIR:-/tmp}/chezmoi-apply-notes.$(id -u)"

# Colors only when we are writing to a terminal that wants them.
COLOR=yes
{ [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; } || COLOR=no

# Kanagawa blues, darkest to lightest and back, so the bar starts and ends on
# the same deep slate. These are waveBlue1, waveBlue2, dragonBlue, dragonBlue2
# and springBlue from the kanagawa.nvim palette.
STOPS=(223249 2D4F67 658594 8ba4b0 7FB4CA 8ba4b0 658594 2D4F67 223249)

# Sets SHADE to the "r;g;b" of step $1 of $2 along STOPS.
shade() {
    local idx=$1 total=$2 n=${#STOPS[@]} pos seg t a b
    pos=$((idx * (n - 1) * 1000 / (total - 1)))
    seg=$((pos / 1000))
    if ((seg > n - 2)); then seg=$((n - 2)); fi
    t=$((pos - seg * 1000))
    a=${STOPS[seg]}
    b=${STOPS[seg + 1]}
    SHADE="$(((16#${a:0:2} * (1000 - t) + 16#${b:0:2} * t) / 1000));"
    SHADE+="$(((16#${a:2:2} * (1000 - t) + 16#${b:2:2} * t) / 1000));"
    SHADE+="$(((16#${a:4:2} * (1000 - t) + 16#${b:4:2} * t) / 1000))"
}

# A thin rule that fades through STOPS. Falls back to plain dashes when the
# output is not a terminal or NO_COLOR is set.
bar() {
    if [ "$COLOR" = no ]; then
        printf '%*s\n' "$WIDTH" '' | tr ' ' '-'
        return
    fi
    local i
    for ((i = 0; i < WIDTH; i++)); do
        shade "$i" "$WIDTH"
        printf '\033[38;2;%sm─' "$SHADE"
    done
    printf '\033[0m\n'
}

dim() { [ "$COLOR" = yes ] && printf '\033[38;2;166;166;156m'; return 0; }
accent() { [ "$COLOR" = yes ] && printf '\033[38;2;122;168;159m'; return 0; }
off() { [ "$COLOR" = yes ] && printf '\033[0m'; return 0; }

echo
bar
echo
echo '                    🏠 is where the ❤️ is.'
echo
printf '                     '
dim
printf 'relaxdiego/dotfiles'
off
echo

if [ -s "$NOTES" ]; then
    echo
    while IFS= read -r note; do
        accent
        printf '  ▸ '
        off
        printf '%s\n' "$note"
    done < "$NOTES"
fi
rm -f "$NOTES"

echo
bar
echo
