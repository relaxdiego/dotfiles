local M = {}

function M.setup(null_ls)
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    -- Function to check if executable is present
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

    -- Map of built-ins to their executables.
    local builtins_to_executables = {
        [code_actions.shellcheck] = "shellcheck",
        [diagnostics.shellcheck] = "shellcheck",
        [formatting.prettierd] = "prettierd",
        [formatting.shellharden] = "shellharden",
    }

    -- Start with base sources (language-specific modules will add more)
    local sources = {
        formatting.stylua.with({
            extra_args = {
                "--indent-type",
                "Spaces",
                "--indent-width",
                "4",
            },
        }),
    }

    -- Add built-ins if their executables are available
    for builtin, executable in pairs(builtins_to_executables) do
        if is_executable_present(executable) then
            table.insert(sources, builtin)
        end
    end

    -- Initialize prettierd if available
    if is_executable_present("prettierd") then
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                local handle = vim.fn.jobstart("prettierd start", {
                    on_stderr = function(_, data)
                        if data and #data > 0 then
                            vim.notify("prettierd error: " .. vim.inspect(data), vim.log.levels.WARN)
                        end
                    end,
                })
                if handle <= 0 then
                    vim.notify("Failed to start prettierd", vim.log.levels.WARN)
                end
            end,
        })
    end

    -- Format HTML/JS/CSS files
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.html", "*.js", "*.css" },
        callback = function()
            vim.lsp.buf.format()
        end,
    })

    -- Set global for other modules to add to
    M.sources = sources

    return sources
end

return M
