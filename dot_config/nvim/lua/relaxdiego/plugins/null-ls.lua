-- FIXME: This plugin has been archived by the author and is no longer maintained.
--        We will need to replace it with https://github.com/nvimtools/none-ls.nvim
--        once it is on par with null-ls and stable.
return {
    "relaxdiego/null-ls.nvim",
    commit = "4f1cfc1", -- Uses ruff format correctly
    event = "VeryLazy",
    config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions

        -- function to check if executable is present
        local function is_executable_present(executable)
            local handle = io.popen("command -v " .. executable)
            if handle then
                local result = handle:read("*a")
                handle:close()
                return result ~= "" and result ~= nil
            else
                return false
            end
        end

        -- map of built-ins to their executables
        local builtins_to_executables = {
            [code_actions.shellcheck] = "shellcheck",
            [diagnostics.mypy] = "mypy",
            [diagnostics.ruff] = "ruff",
            [diagnostics.shellcheck] = "shellcheck",
            [formatting.prettierd] = "prettierd",
            [formatting.shellharden] = "shellharden",
        }

        -- construct sources list with available executables
        local sources = {
            formatting.stylua,
        }
        for builtin, executable in pairs(builtins_to_executables) do
            if is_executable_present(executable) then
                table.insert(sources, builtin)
            end
        end

        -- BEGIN: Custom ruff formatting sources
        -- Because, for some reason, some fixes are implemented via "ruff check
        -- --fix" while others or done via "ruff format"
        -- See: https://github.com/astral-sh/ruff/discussions/9048
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
        table.insert(sources, ruff_check_fix)

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
        table.insert(sources, ruff_format)
        -- END: Custom ruff formatting sources

        null_ls.setup({
            -- Set this to true to start logging
            -- Also use ":checkhealth null-ls" for more troubleshooting
            -- debug = true,
            log_level = "warn",
            -- See available sources: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
            sources = sources,
        })
    end,
}
