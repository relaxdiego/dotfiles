local M = {}

-- Import the shared LSP utilities
local lsp_utils = require("relaxdiego.plugins.lsp")

function M.setup(ctx)
    -- Get enhanced capabilities from shared utilities
    local capabilities = lsp_utils.get_capabilities()

    -- Create a JSON-specific on_attach function that extends the common one
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- JSON-specific keybindings
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Format JSON if not devbox.json
        vim.keymap.set("n", "<leader>jf", function()
            local filename = vim.fn.expand("%:t")
            if filename ~= "devbox.json" then
                vim.lsp.buf.format({ timeout_ms = 2000 })
            else
                vim.notify("Formatting skipped for devbox.json (treated as json5)", vim.log.levels.INFO)
            end
        end, opts)

        -- Fix JSON with jq (if available)
        if lsp_utils.is_executable("jq") then
            vim.keymap.set("n", "<leader>jx", function()
                vim.cmd("%!jq .")
            end, opts)
        end

        -- Toggle between JSON view modes (expanded/compressed)
        vim.keymap.set("n", "<leader>jt", function()
            -- Get the current buffer content
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local content = table.concat(lines, "\n")

            -- Try to parse as JSON
            local success, result = pcall(function()
                return vim.fn.json_decode(content)
            end)

            if not success then
                vim.notify("Invalid JSON", vim.log.levels.ERROR)
                return
            end

            -- Check if the current view is expanded or compressed
            local is_expanded = #lines > 5 -- Simple heuristic

            -- Toggle between expanded and compressed
            local new_content
            if is_expanded then
                -- Compress
                new_content = vim.fn.json_encode(result)
                vim.notify("JSON compressed", vim.log.levels.INFO)
            else
                -- Expand
                new_content = vim.fn.json_encode(result, { pretty = true })
                vim.notify("JSON expanded", vim.log.levels.INFO)
            end

            -- Update buffer content
            vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(new_content, "\n"))
        end, opts)
    end)

    -- Setup jsonls for JSON
    require("lspconfig").jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            json = {
                -- Use schemastore.nvim for schema collection
                schemas = require("schemastore").json.schemas({
                    replace = {
                        ["devcontainer.json"] = {
                            description = "devcontainer.json override",
                            fileMatch = { "devcontainer.json" },
                            name = "devcontainer.json",
                            url = "https://raw.githubusercontent.com/relaxdiego/SchemaStoreOverrides/main/schemas/devContainer.schema.json",
                        },
                    },
                }),
                validate = { enable = true },
                format = { enable = true },
            },
        },
        commands = {
            -- Add LSP commands for common JSON operations
            Format = {
                function()
                    vim.lsp.buf.format({ async = true })
                end,
                description = "Format JSON document",
            },
        },
    })

    -- Format JSON files on save (except for devbox.json)
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.json",
        callback = function()
            local file = vim.fn.expand("<afile>")
            local filename = vim.fn.fnamemodify(file, ":t")
            if filename ~= "devbox.json" then
                vim.lsp.buf.format({ timeout_ms = 3000 })
            end
        end,
    })

    -- Special handling for devbox.json
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "devbox.json",
        callback = function()
            vim.bo.filetype = "json5"
        end,
    })

    -- Set JSON-specific options on file load
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "json", "jsonc", "json5" },
        callback = function()
            -- Set JSON-specific options
            vim.opt_local.tabstop = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.expandtab = true
        end,
    })

    -- Add linters or formatters to null-ls if appropriate
    if ctx.null_ls and lsp_utils.is_executable("jq") then
        local formatting = ctx.null_ls.builtins.formatting
        table.insert(ctx.null_ls_sources, formatting.jq)
    end
end

return M
