local M = {}

-- Import the shared LSP utilities
local lsp_utils = require("relaxdiego.plugins.lsp")

function M.setup(ctx)
    -- Get enhanced capabilities from shared utilities
    local capabilities = lsp_utils.get_capabilities()

    -- Create a Go-specific on_attach function that extends the common one
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- Go-specific keybindings
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Add keymap for organizing imports
        vim.keymap.set("n", "<leader>gi", function()
            vim.cmd("GoImports")
        end, opts)

        -- Add keymap for running tests
        vim.keymap.set("n", "<leader>gt", function()
            vim.cmd("GoTest")
        end, opts)

        -- Add keymap for generating interface stubs
        vim.keymap.set("n", "<leader>gI", function()
            vim.cmd("GoImpl")
        end, opts)
    end)

    -- Setup gopls for Go
    local util = require("lspconfig/util")
    require("lspconfig").gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                gofumpt = true,
                analyses = {
                    unusedparams = true,
                    unusedwrite = true,
                    nilness = true,
                    shadow = true,
                },
                staticcheck = true,
                templateExtensions = { "tmpl" },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    })

    -- Command to organize imports in Go
    vim.cmd([[
        command! GoImports lua vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    ]])

    -- Format on save for Go files
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.go", "*.gomod", "*.gosum" },
        callback = function()
            vim.lsp.buf.format({ timeout_ms = 3000 })
        end,
    })

    -- Add Go test template creator
    vim.api.nvim_create_user_command("GoTestTemplate", function()
        local template = {
            "func Test(t *testing.T) {",
            "\t// Arrange",
            "\t",
            "\t// Act",
            "\t",
            "\t// Assert",
            "\t",
            "}",
        }
        vim.api.nvim_put(vim.split(table.concat(template, "\n"), "\n"), "l", true, true)
        -- Position cursor after Test to enter the name
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { pos[1] - 7, 9 })
    end, { desc = "Insert Go test function template" })
end

return M
