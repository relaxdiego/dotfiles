{{/*
The drawing code behind the two `chezmoi apply` banners: the opening line in
run_before_000_applying_revision.sh.tmpl and the closing box in
run_after_final_home_is_where_the_heart_is.sh.tmpl. Both pull it in with
{{ template "banner.sh" . }}, so this is a fragment of bash, not a script of
its own.
*/ -}}
WIDTH=62

# Colors only when we are writing to a terminal that wants them.
COLOR=yes
{ [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; } || COLOR=no

# Kanagawa blues, darkest to lightest and back, so the bar starts and ends on
# the same deep slate. These are waveBlue1, waveBlue2, dragonBlue, dragonBlue2
# and springBlue from the kanagawa.nvim palette.
STOPS=(223249 2D4F67 658594 8ba4b0 7FB4CA 8ba4b0 658594 2D4F67 223249)

# The same blues, but only the light half. Shading the title across the full
# STOPS would leave its first and last letters too dark to read.
TITLE_STOPS=(658594 8ba4b0 7FB4CA 8ba4b0 658594)

# Sets SHADE to the "r;g;b" of step $1 of $2 along STOPS, or along the stops
# given as $3 ("aaaaaa bbbbbb ...").
shade() {
    local idx=$1 total=$2 pos seg t a b n
    local stops=(${3:-${STOPS[*]}})
    n=${#stops[@]}
    pos=$((idx * (n - 1) * 1000 / (total - 1)))
    seg=$((pos / 1000))
    if ((seg > n - 2)); then seg=$((n - 2)); fi
    t=$((pos - seg * 1000))
    a=${stops[seg]}
    b=${stops[seg + 1]}
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

# The padding that puts something $1 characters wide in the middle of the bar.
indent() { printf '%*s' $(((WIDTH - $1) / 2)) ''; }

dim() { [ "$COLOR" = yes ] && printf '\033[38;2;166;166;156m'; return 0; }
accent() { [ "$COLOR" = yes ] && printf '\033[38;2;122;168;159m'; return 0; }
off() { [ "$COLOR" = yes ] && printf '\033[0m'; return 0; }

# $1 shaded letter by letter along TITLE_STOPS, so the title and the rules
# above and below it read as one object.
title() {
    if [ "$COLOR" = no ]; then
        printf '%s' "$1"
        return
    fi
    local i n=${#1}
    for ((i = 0; i < n; i++)); do
        shade "$i" "$n" "${TITLE_STOPS[*]}"
        printf '\033[38;2;%sm%s' "$SHADE" "${1:i:1}"
    done
    printf '\033[0m'
}
