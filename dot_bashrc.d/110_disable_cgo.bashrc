if [[ "$(uname)" == "Darwin" ]]; then
    # Avoid any possible C-related compilation errors in macOS
    export CGO_ENABLED=0
fi
