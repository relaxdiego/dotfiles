local M = {}

-- Import the shared LSP utilities
local lsp_utils = require("relaxdiego.plugins.lsp")

function M.setup(ctx)
    -- Get enhanced capabilities from shared utilities
    local capabilities = lsp_utils.get_capabilities()

    -- Create a Python-specific on_attach function that extends the common one
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- Python-specific keybindings
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Add Python debug logging statement
        vim.keymap.set("n", "<leader>pd", function()
            local log_stmt = 'logger.debug(f"")'
            vim.api.nvim_put(vim.split(log_stmt, "\n"), "", false, true)
            -- Move cursor to position between quotes
            local curr_pos = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_win_set_cursor(0, { curr_pos[1], curr_pos[2] - 1 })
        end, opts)

        -- Add Python Arrange, Act, Assert test structure
        vim.keymap.set("n", "<leader>pt", function()
            local test_structure = {
                "# Arrange",
                "",
                "# Act",
                "",
                "# Assert",
                "",
            }
            vim.api.nvim_put(test_structure, "l", true, true)
        end, opts)
    end)

    -- 1. Pyright for type checking, with optimized settings
    require("lspconfig").pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            pyright = {
                disableOrganizeImports = true, -- Let Ruff handle this
            },
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "openFilesOnly", -- Avoid resource-intensive workspace mode
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = "standard",
                    ignore = { ".venv" },
                },
            },
        },
    })

    -- 2. pylsp for other Python functionality
    require("lspconfig").pylsp.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            -- Call the regular on_attach function
            on_attach(client, bufnr)
            
            -- Disable formatting for pylsp to avoid conflicts with Ruff
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
            pylsp = {
                plugins = {
                    -- Disable features covered by pyright or ruff
                    pycodestyle = { enabled = false },
                    pyflakes = { enabled = false },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    -- Disable formatting plugins to avoid conflicts
                    black = { enabled = false },
                    -- Enable other useful plugins
                    rope_completion = { enabled = true },
                    rope_autoimport = { enabled = true },
                },
            },
        },
    })

    -- Format on save for Python files with increased timeout
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
            vim.lsp.buf.format({ timeout_ms = 5000 })
        end,
    })

    -- Add custom Ruff configuration for Python
    -- This gets added to the global null_ls_sources table
    if not ctx.null_ls_sources then
        ctx.null_ls_sources = {}
    end

    -- Custom Ruff check and fix command
    local h = require("null-ls.helpers")
    local FORMATTING = require("null-ls.methods").internal.FORMATTING

    local ruff_check_fix = h.make_builtin({
        name = "ruff_check_fix",
        meta = {
            url = "https://github.com/charliermarsh/ruff/",
            description = "An extremely fast Python linter, written in Rust.",
        },
        method = FORMATTING,
        filetypes = { "python" },
        generator_opts = {
            command = "ruff",
            args = {
                "check",
                "--fix",
                "--stdin-filename",
                "$FILENAME",
                "-",
            },
            to_stdin = true,
        },
        factory = h.formatter_factory,
    })
    table.insert(ctx.null_ls_sources, ruff_check_fix)

    -- Custom Ruff format command
    local ruff_format = h.make_builtin({
        name = "ruff_format",
        meta = {
            url = "https://github.com/charliermarsh/ruff/",
            description = "An extremely fast Python linter, written in Rust.",
        },
        method = FORMATTING,
        filetypes = { "python" },
        generator_opts = {
            command = "ruff",
            args = {
                "format",
                "--stdin-filename",
                "$FILENAME",
                "-",
            },
            to_stdin = true,
        },
        factory = h.formatter_factory,
    })
    table.insert(ctx.null_ls_sources, ruff_format)

    -- Add Python-specific logging utilities as commands
    vim.api.nvim_create_user_command("PyLoggingImport", function()
        local import_stmt = "import logging\nlogger = logging.getLogger(__name__)"
        vim.api.nvim_put(vim.split(import_stmt, "\n"), "", false, true)
    end, { desc = "Add Python logging import statements" })
end

return M
