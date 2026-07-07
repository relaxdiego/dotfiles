#!/bin/bash
# verify-inventory.sh — report this host's installed dev tools (path + version).
#
# For each common CLI tool, it resolves the binary actually on PATH and prints
# its live version. The point is to MEASURE the running host instead of guessing
# from install scripts or version pins — useful for taking a software inventory
# before a security / CVE review.
#
# Output reflects ONLY the machine it runs on: Homebrew, nvm, and "latest"-pinned
# tools differ between hosts, so re-run it on each machine. Tools not installed
# here are simply reported as ABSENT.
#
# Usage:  ./scripts/verify-inventory.sh
# Read-only: it installs nothing and changes nothing.
#
# grep/find caveat: an interactive shell may define `grep`/`find` as aliases or
# functions that wrap a different tool, so a manual `grep --version` can report
# the wrong thing. Running as a plain subprocess (as this script does) bypasses
# that and reports the real binaries. ~/.bashrc is sourced only to pick up your
# normal PATH.
source ~/.bashrc 2>/dev/null || true

# Print one tool's resolved path + parsed version.
#   probe <label> <binary> <verarg>
#   verarg "-"  => tool has no version flag; mark n/a (check manually / via brew)
probe() {
  local label="$1" bin="$2" verarg="$3" path ver
  path="$(command -v "$bin" 2>/dev/null)"
  if [ -z "$path" ]; then
    printf '  %-22s | %-8s | %s\n' "$label" "ABSENT" "(not on PATH)"
    return
  fi
  if [ "$verarg" = "-" ]; then
    ver="(no version flag — verify manually)"
  else
    # Grab the first version-like token from the tool's own output. Permissive
    # on purpose: handles 1.22.1, 3.5a, 1.7.1-apple, go1.26.4, 6.1.0(p...), etc.
    ver="$("$bin" "$verarg" 2>&1 | grep -oiE '[0-9]+\.[0-9][0-9a-z.+_-]*' | head -1)"
    [ -z "$ver" ] && ver="(unparsed — run: $bin $verarg)"
  fi
  printf '  %-22s | %-8s | %-52s | %s\n' "$label" "present" "$path" "$ver"
}

echo "=== Standalone binaries ==="
probe starship       starship       --version
probe fzf            fzf            --version
probe golangci-lint  golangci-lint  --version
probe gofumpt        gofumpt        --version
probe k9s            k9s            version
probe gh             gh             --version
probe neovim         nvim           --version
probe git-delta      delta          --version
probe tflint         tflint         --version
probe ruff           ruff           --version
probe lazygit        lazygit        --version
probe krew           kubectl-krew   version
probe devcontainer   devcontainer   --version

echo
echo "=== Floating / latest versions ==="
probe go             go             version
probe goimports      goimports      -
probe node           node           --version
probe npm            npm            --version
probe kubectx        kubectx        -
probe kubens         kubens         -
# nvm is a shell function, not a binary on PATH — source it to read its version.
nvm_ver="$(bash -c '. "$HOME/.nvm/nvm.sh" 2>/dev/null && nvm --version' 2>/dev/null)"
printf '  %-22s | %-8s | %-52s | %s\n' "nvm" \
  "$([ -n "$nvm_ver" ] && echo present || echo ABSENT)" \
  "$HOME/.nvm/nvm.sh" "${nvm_ver:-(not found)}"

echo
echo "=== Package-manager installs (brew / apt) ==="
probe wget           wget           --version
probe cmake          cmake          --version
probe jq             jq             --version
probe gnu-tar        tar            --version
probe gzip           gzip           --version
probe universal-ctags ctags         --version
probe gnupg2         gpg            --version
probe vim            vim            --version
probe silver-searcher ag            --version
probe tmux           tmux           -V
probe git            git            --version
probe git-lfs        git-lfs        --version
probe grep           grep           --version
probe find           find           --version
probe direnv         direnv         --version
probe pipenv         pipenv         --version
probe shellcheck     shellcheck     --version
probe bat            bat            --version
probe ripgrep        rg             --version
probe shellharden    shellharden    --version
probe fd             fd             --version
probe devbox         devbox         version
probe homebrew       brew           --version

echo
echo "=== Authoritative Homebrew versions (cross-check) ==="
echo "  (for brew-managed tools, and for kubectx/kubens which lack a version flag)"
brew list --versions 2>/dev/null | sed 's/^/  /'
