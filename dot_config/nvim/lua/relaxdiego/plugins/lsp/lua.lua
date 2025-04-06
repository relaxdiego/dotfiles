local M = {}

-- Import the shared LSP utilities
local lsp_utils = require("relaxdiego.plugins.lsp")

function M.setup(ctx)
    -- Get enhanced capabilities from shared utilities
    local capabilities = lsp_utils.get_capabilities()

    -- Create a Lua-specific on_attach function that extends the common one
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- Lua-specific keybindings
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Quick access to Neovim runtime files
        vim.keymap.set("n", "<leader>lr", function()
            vim.cmd("edit " .. vim.fn.stdpath("config"))
        end, opts)

        -- Insert Neovim module template
        vim.keymap.set("n", "<leader>lm", function()
            local template = {
                "local M = {}",
                "",
                "function M.setup()",
                "    -- TODO: Add setup code here",
                "end",
                "",
                "return M",
                "",
            }
            vim.api.nvim_put(vim.split(table.concat(template, "\n"), "\n"), "l", true, true)
        end, opts)
    end)

    -- Setup lua_ls for Lua
    require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                        "vim",
                        -- Neovim specific globals
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        -- Commonly used testing globals
                        "assert",
                    },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    -- Disable third-party library checking which can be slow
                    checkThirdParty = false,
                    -- Configure workspace detection for better support
                    maxPreload = 2000,
                    preloadFileSize = 1000,
                },
                -- Do not send telemetry data
                telemetry = {
                    enable = false,
                },
                -- Formatting handled by stylua
                format = {
                    enable = false,
                },
                -- Configure completion
                completion = {
                    callSnippet = "Replace",
                    keywordSnippet = "Replace",
                    displayContext = 5,
                },
            },
        },
    })

    -- Format on save for Lua files using stylua via null-ls
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.lua",
        callback = function()
            vim.lsp.buf.format({ timeout_ms = 2000 })
        end,
    })

    -- Ensure stylua is in the null-ls sources if it's available
    if lsp_utils.is_executable("stylua") then
        local formatting = ctx.null_ls.builtins.formatting

        -- Add stylua to the sources (if not already added in null_ls.lua)
        table.insert(
            ctx.null_ls_sources,
            formatting.stylua.with({
                extra_args = {
                    "--indent-type",
                    "Spaces",
                    "--indent-width",
                    "4",
                },
            })
        )
    end

    -- Add Neovim-specific Lua snippets
    local has_luasnip, luasnip = pcall(require, "luasnip")
    if has_luasnip then
        luasnip.add_snippets("lua", {
            -- Plugin setup template for Lazy.nvim
            luasnip.snippet("plugin", {
                luasnip.text_node({ "return {", "    " }),
                luasnip.insert_node(1, "plugin_name"),
                luasnip.text_node({ ",", "    " }),
                luasnip.insert_node(2, "-- options"),
                luasnip.text_node({ ",", "    config = function()", "        " }),
                luasnip.insert_node(3, "-- configuration"),
                luasnip.text_node({ "", "    end,", "}" }),
            }),
        })
    end
end

return M
