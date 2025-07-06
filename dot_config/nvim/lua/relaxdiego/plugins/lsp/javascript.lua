--[[
JavaScript Language Server Configuration

This module configures the TypeScript language server (tsserver) for JavaScript
development. It provides:
- IntelliSense and code completion
- Error checking and diagnostics
- Code navigation (go to definition, find references)
- Refactoring support
- Formatting capabilities

The configuration uses tsserver which provides excellent JavaScript support
including modern ES6+ features and Node.js APIs.
--]]

local M = {}

function M.setup(ctx)
    local lsp_utils = require("relaxdiego.plugins.lsp")
    local lspconfig = require("lspconfig")
    
    -- Enhanced capabilities for JavaScript
    local capabilities = ctx.capabilities
    
    -- Custom on_attach with JavaScript-specific features
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- TypeScript server provides formatting, but we might prefer prettier
        -- Disable tsserver formatting if prettier is available
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        
        -- Additional JavaScript-specific keymaps
        local opts = { buffer = bufnr, noremap = true, silent = true }
        
        -- Organize imports
        vim.keymap.set("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
                filter = function(action)
                    return action.kind == "source.organizeImports"
                end,
                apply = true,
            })
        end, opts)
        
        -- Remove unused imports
        vim.keymap.set("n", "<leader>ru", function()
            vim.lsp.buf.code_action({
                filter = function(action)
                    return action.kind == "source.removeUnused"
                end,
                apply = true,
            })
        end, opts)
    end)
    
    -- Configure tsserver for JavaScript
    lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
    })
    
    -- Add prettier for formatting if available
    if lsp_utils.is_executable("prettier") then
        table.insert(ctx.null_ls_sources, ctx.null_ls.builtins.formatting.prettier.with({
            filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "vue",
                "css",
                "scss",
                "less",
                "html",
                "json",
                "jsonc",
                "yaml",
                "markdown",
                "markdown.mdx",
                "graphql",
                "handlebars",
            },
        }))
    end
    
    -- Add ESLint for linting if available
    if lsp_utils.is_executable("eslint") then
        table.insert(ctx.null_ls_sources, ctx.null_ls.builtins.diagnostics.eslint)
        table.insert(ctx.null_ls_sources, ctx.null_ls.builtins.code_actions.eslint)
    end
end

return M