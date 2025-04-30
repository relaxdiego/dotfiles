--[[
LSP Utilities Module

This module provides shared functionality for all language-specific LSP configurations.
It centralizes common utilities to ensure consistency and reduce duplication across
language-specific modules.

Usage in language modules:

```lua
-- At the top of any language module (e.g., python.lua)
local lsp_utils = require("relaxdiego.plugins.lsp")

function M.setup(ctx)
    -- Get enhanced capabilities including nvim-cmp integration
    local capabilities = lsp_utils.get_capabilities()

    -- Create an on_attach function with both common and custom behavior
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- Language-specific additions here
        vim.keymap.set('n', '<leader>x', my_custom_function, { buffer = bufnr })
    end)

    -- Use in LSP server setup
    require("lspconfig").my_language_server.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        -- Other settings...
    })
end
```

The module is designed to maintain a consistent interface across all language
configurations while allowing for language-specific customizations.
--]]

local M = {}

---Generate enhanced LSP capabilities including nvim-cmp integration
---@return table capabilities Enhanced capabilities object
M.get_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Additional capability customizations
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    return capabilities
end

---Common LSP on_attach function that can be used by any language
---Sets up standard keybindings and functionality for LSP
---@param client table The LSP client instance
---@param bufnr number The buffer number
M.on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Buffer local mappings
    local opts = { buffer = bufnr, noremap = true, silent = true }

    -- Apply common keymaps used by all language servers
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

    -- Set autocommands conditional on server capabilities

    --
    -- Disabling this since it's slightly buggy: sometimes it just doesn't clear
    -- the highlight unless I reload the buffer with `:e!`
    --
    -- if client.server_capabilities.documentHighlightProvider then
    --     vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    --     vim.api.nvim_clear_autocmds({ group = "lsp_document_highlight", buffer = bufnr })
    --     vim.api.nvim_create_autocmd("CursorHold", {
    --         callback = vim.lsp.buf.document_highlight,
    --         buffer = bufnr,
    --         group = "lsp_document_highlight",
    --         desc = "Document Highlight",
    --     })
    --     vim.api.nvim_create_autocmd("CursorMoved", {
    --         callback = vim.lsp.buf.clear_references,
    --         buffer = bufnr,
    --         group = "lsp_document_highlight",
    --         desc = "Clear All the References",
    --     })
    -- end

    -- Formatting capabilities check
    if client.server_capabilities.documentFormattingProvider then
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end
end

---Check if an executable exists in PATH
---@param executable string The name of the executable to check
---@return boolean exists Whether the executable exists and is accessible
M.is_executable = function(executable)
    local handle = io.popen("command -v " .. executable)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= "" and result ~= nil
    else
        return false
    end
end

---Create a custom on_attach function that extends the common one
---This allows language-specific modules to add their own functionality
---while still using the common keybindings
---@param callback function|nil Optional function to run after common on_attach
---@return function on_attach The combined on_attach function
M.create_on_attach = function(callback)
    return function(client, bufnr)
        -- First apply common on_attach
        M.on_attach(client, bufnr)

        -- Then apply custom callback
        if callback then
            callback(client, bufnr)
        end
    end
end

---Setup diagnostic signs with specified icons
---@param signs table A table mapping diagnostic types to icons
M.setup_diagnostic_signs = function(signs)
    signs = signs or {
        Error = "",
        Warn = "",
        Hint = "󰉀",
        Info = "",
    }

    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

---Configure diagnostic display preferences
---@param config table|nil Optional table with diagnostic configuration
M.setup_diagnostics = function(config)
    config = config
        or {
            virtual_text = {
                prefix = "●",
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                source = true,
                border = "single",
                style = "minimal",
            },
        }

    vim.diagnostic.config(config)
end

return M
