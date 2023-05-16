#!/bin/bash

set -euo pipefail

repo="https://github.com/ahmetb/kubectx"
version="979012e0941830e14b8f73b5e2112811d0fd5d83"
clonedir="$HOME/bin/kubectx.git"

if ! which go >/dev/null; then
    echo "go not found. Skipping installation of kubectx"
    echo "Run install-go if you want kubectx"
    exit 0
fi

echo "Installing kubectx..."

if [ ! -d "$clonedir" ]; then
    git clone "$repo" "$clonedir"
fi
cd "$clonedir"
git checkout "$version"
go build ./...
cd "$HOME/bin"
ln -f -s "$clonedir/kubectx" kubectx
ln -f -s "$clonedir/kubens" kubens
