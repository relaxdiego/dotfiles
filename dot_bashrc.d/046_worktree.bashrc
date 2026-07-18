# Clone a repo into the bare + equal-worktrees layout:
#   ~/src/<host>/<owner>/<repo>/.bare        (bare git data)
#   ~/src/<host>/<owner>/<repo>/<branch>/    (default branch as a worktree)
# Leaves you inside the default branch's worktree.
#
#   clone git@github.com:owner/repo.git
#   clone https://github.com/owner/repo
#
# To add more worktrees later, cd into any worktree and:
#   git worktree add ../<dir> <branch>            # existing branch
#   git worktree add ../<dir> -b <new> origin/<branch>
clone() {
    local url="$1"
    if [ -z "$url" ]; then
        echo "usage: clone <git-url>" >&2
        return 1
    fi

    # derive host/owner/repo from the common URL forms
    local s="$url"
    s="${s#*://}"        # drop scheme://

    # keep an explicit ssh user (user@host...), if any; default to git below
    local user=
    case "${s%%[/:]*}" in
        *@*) user="${s%%@*}"; s="${s#*@}" ;;
    esac

    s="${s/:/\/}"        # first ':' -> '/' (scp-style host:owner/repo)
    s="${s%/}"           # drop trailing slash

    # suffix appended to host:path when rebuilding the remote url. a source in
    # bare+worktree layout points straight at its .bare git dir, so clone that
    # verbatim and keep .bare out of the local identity. anything else is a
    # normal host/owner/repo and gets .git.
    local rsuffix=.git
    case "$s" in
        */.bare) rsuffix=/.bare; s="${s%/.bare}" ;;
        *.git)   s="${s%.git}" ;;
    esac

    local container="$HOME/src/$s"
    if [ -e "$container/.bare" ]; then
        echo "clone: already exists: $container" >&2
        return 1
    fi

    mkdir -p "$container" || return 1

    # If the repo is not reachable over the given protocol, retry with the
    # others. Try the provided protocol first, then the other URL form, then
    # `gh repo clone`, until one succeeds or all fail.
    local host="${s%%/*}"   # host
    local path="${s#*/}"    # owner/repo
    local first second
    case "$url" in
        git@*|ssh://*|*@*:*) first=ssh;   second=https ;;
        *)                   first=https; second=ssh ;;
    esac

    local proto cloned=
    for proto in "$first" "$second" gh; do
        case "$proto" in
            ssh)   git clone --bare -- "${user:-git}@$host:$path$rsuffix" "$container/.bare" ;;
            https) git clone --bare -- "https://$host/$path$rsuffix" "$container/.bare" ;;
            gh)    if command -v gh >/dev/null 2>&1; then
                       gh repo clone "$path" "$container/.bare" -- --bare
                   else
                       false
                   fi ;;
        esac
        if [ $? -eq 0 ]; then
            cloned=1
            break
        fi
        rm -rf "$container/.bare"
    done
    if [ -z "$cloned" ]; then
        rmdir "$container" 2>/dev/null
        return 1
    fi

    # a bare clone sets no remote-tracking refspec; fix it so `git fetch`
    # populates refs/remotes/origin/* and worktrees track upstream properly
    git --git-dir "$container/.bare" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    git --git-dir "$container/.bare" fetch -q origin

    # default branch = the bare repo's HEAD; fall back to main
    local def
    def="$(git --git-dir "$container/.bare" symbolic-ref --short HEAD 2>/dev/null)"
    [ -n "$def" ] || def=main

    git --git-dir "$container/.bare" worktree add "$container/${def//\//-}" "$def" \
        && cd "$container/${def//\//-}"
}
