require("mason-null-ls").setup({
    ensure_installed = {
        "black",
        "flake8",
        "gofumpt",
        "isort",
        "jq",
        "luaformatter",
        "markdown-toc",
        "markdownlint",
        "shellcheck",
        "shfmt",
        "yamlfmt",
    }
})
