{{/*
The drawing code behind the two `chezmoi apply` banners: the opening line in
run_before_000_applying_revision.sh.tmpl and the closing box in
run_after_final_home_is_where_the_heart_is.sh.tmpl. Both pull it in with
{{ template "banner.sh" . }}, so this is a fragment of bash, not a script of
its own.
*/ -}}
WIDTH=62

# Colors only when we are writing to a terminal that wants them and can show
# them. A pipe, NO_COLOR, an unset or dumb TERM, or a missing tput all drop us
# to plain text.
COLOR=yes
{ [ -t 1 ] && [ -z "${NO_COLOR:-}" ] &&
    [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; } || COLOR=no

# The rule, the bullet and the house need a UTF-8 locale to encode. This says
# only that the locale can carry them. Whether the font has a picture for the
# house is not something a shell can ask, so a missing emoji still shows up as
# an empty box.
UNICODE=yes
case "$(locale charmap 2>/dev/null)" in
    UTF-8 | utf8 | UTF8) ;;
    *) UNICODE=no ;;
esac

if [ "$UNICODE" = yes ]; then
    RULE='─'
    BULLET='▸'
    SEP='—'
else
    RULE='-'
    BULLET='>'
    SEP='-'
fi

# Kanagawa blues, darkest to lightest and back, so the bar starts and ends on
# the same deep slate. These are waveBlue1, waveBlue2, dragonBlue, dragonBlue2
# and springBlue from the kanagawa.nvim palette.
STOPS=(223249 2D4F67 658594 8ba4b0 7FB4CA 8ba4b0 658594 2D4F67 223249)

# Sets SHADE to the "r;g;b" of step $1 of $2 along STOPS.
shade() {
    local idx=$1 total=$2 pos seg t a b n
    n=${#STOPS[@]}
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
        printf '\033[38;2;%sm%s' "$SHADE" "$RULE"
    done
    printf '\033[0m\n'
}

# The padding that puts something $1 characters wide in the middle of the bar.
indent() { printf '%*s' $(((WIDTH - $1) / 2)) ''; }

bold() { [ "$COLOR" = yes ] && printf '\033[1m'; return 0; }
dim() { [ "$COLOR" = yes ] && printf '\033[38;2;166;166;156m'; return 0; }
accent() { [ "$COLOR" = yes ] && printf '\033[38;2;122;168;159m'; return 0; }
off() { [ "$COLOR" = yes ] && printf '\033[0m'; return 0; }

# springBlue, the brightest stop in the bar above, so the title and the rule
# read as one object.
bright() { [ "$COLOR" = yes ] && printf '\033[38;2;127;180;202m'; return 0; }

# Palette yellow. `git ta` colors a commit hash with this same plain escape
# (%C(auto)%h -> \033[33m), so a sha here matches one in the git log whatever
# the terminal theme is.
sha() { [ "$COLOR" = yes ] && printf '\033[33m'; return 0; }

# The source revision. Both banners print it, so the pair brackets one apply.
# Recomputed at each end rather than passed along: a run_ script can dirty the
# source (lazy.nvim rewriting .nvim/lazy-lock.json), and the closing banner
# should say so.
SRC='{{ .chezmoi.sourceDir }}'
REV="$(git -C "$SRC" rev-parse --short HEAD 2>/dev/null)" || REV=unknown
if [ -n "$(git -C "$SRC" status --porcelain 2>/dev/null)" ]; then
    REV="$REV-dirty"
fi
