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
    s="${s#*@}"          # drop user@
    s="${s/:/\/}"        # first ':' -> '/' (scp-style host:owner/repo)
    s="${s%.git}"        # drop trailing .git
    s="${s%/}"           # drop trailing slash

    local container="$HOME/src/$s"
    if [ -e "$container/.bare" ]; then
        echo "clone: already exists: $container" >&2
        return 1
    fi

    mkdir -p "$container" || return 1
    if ! git clone --bare "$url" "$container/.bare"; then
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
