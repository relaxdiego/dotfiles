local M = {}

-- Import the shared LSP utilities
local lsp_utils = require("relaxdiego.plugins.lsp")

function M.setup(ctx)
    -- Get enhanced capabilities from shared utilities
    local capabilities = lsp_utils.get_capabilities()

    -- Create a YAML-specific on_attach function that extends the common one
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- YAML-specific keybindings
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Format YAML document
        vim.keymap.set("n", "<leader>yf", function()
            vim.lsp.buf.format({ timeout_ms = 2000 })
        end, opts)

        -- Toggle document outline
        vim.keymap.set("n", "<leader>yo", function()
            -- Try to use either Aerial or Telescope to show document symbols
            local has_aerial, _ = pcall(require, "aerial")
            if has_aerial then
                vim.cmd("AerialToggle")
            else
                -- Fallback to LSP document symbols via Telescope
                local has_telescope, telescope = pcall(require, "telescope.builtin")
                if has_telescope then
                    telescope.lsp_document_symbols()
                else
                    -- Ultimate fallback to LSP document symbols
                    vim.cmd("LspDocumentSymbols")
                end
            end
        end, opts)

        -- Add a comment header for YAML sections
        vim.keymap.set("n", "<leader>yh", function()
            local width = 60
            local comment = string.rep("#", width)
            local header = "#" .. string.rep(" ", (width - 4) / 2) .. "" .. string.rep(" ", (width - 4) / 2) .. "#"

            local lines = {
                comment,
                header,
                "#" .. string.rep(" ", width - 2) .. "#",
                comment,
                "",
            }

            -- Insert the header at current cursor position
            vim.api.nvim_put(lines, "l", true, true)

            -- Move cursor to the middle line to add the title
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_win_set_cursor(0, { cursor_pos[1] - 3, (width - 4) / 2 + 1 })

            -- Enter insert mode
            vim.cmd("startinsert")
        end, opts)
    end)

    -- Setup yamlls for YAML
    require("lspconfig").yamlls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            yaml = {
                validate = true,
                completion = true,
                hover = true,
                format = {
                    enable = true,
                    singleQuote = false,
                    bracketSpacing = true,
                    proseWrap = "preserve",
                    printWidth = 120,
                },
                schemaStore = {
                    enable = false,
                    url = "",
                },
                -- Use schemastore.nvim for schema collection
                schemas = require("schemastore").yaml.schemas(),
                -- Additional schema associations for specific file patterns
                schemaMapping = {
                    ["docker-compose*.yml"] =
                    "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
                    ["kustomization.yaml"] = "https://json.schemastore.org/kustomization.json",
                    ["helm/**/values.yaml"] =
                    "https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json",
                },
                -- Additional custom tags for specialized YAML applications
                customTags = {
                    "!include_dir_named",
                    "!include_dir_list",
                    "!include_dir_merge_list",
                    "!include_dir_merge_named",
                    "!include",
                    "!secret",
                    "!env_var",
                    -- Ansible tags
                    "!vault",
                    "!unsafe",
                    -- CloudFormation tags
                    "!Ref",
                    "!Sub",
                    "!Join sequence",
                    "!GetAtt",
                    "!GetAZs",
                    "!Cidr",
                    "!ImportValue",
                },
            },
        },
    })

    -- Apply proper indentation for YAML files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "yaml",
        callback = function()
            -- Set YAML-specific options
            vim.opt_local.tabstop = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.expandtab = true
        end,
    })

    -- Special handling for YAML files that are templates
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.y*ml.tmpl",
        callback = function()
            vim.bo.filetype = "yaml"
        end,
    })

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.y*ml.template",
        callback = function()
            vim.bo.filetype = "yaml"
        end,
    })

    -- Handle Helm templates as YAML
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*/templates/*.yaml",
        callback = function()
            vim.bo.filetype = "yaml"
        end,
    })

    -- Add YAML snippet commands
    vim.api.nvim_create_user_command("YAMLResource", function()
        local template = {
            "---",
            "# Resource definition",
            "apiVersion: v1",
            "kind: ",
            "metadata:",
            "  name: ",
            "  namespace: default",
            "spec:",
            "  ",
            "",
        }
        vim.api.nvim_put(vim.split(table.concat(template, "\n"), "\n"), "l", true, true)

        -- Position cursor at the kind field
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { cursor_pos[1] - 6, 6 })
    end, { desc = "Insert YAML Kubernetes resource template" })

    -- Add yamllint if available
    if lsp_utils.is_executable("yamllint") and ctx.null_ls then
        local diagnostics = ctx.null_ls.builtins.diagnostics
        table.insert(ctx.null_ls_sources, diagnostics.yamllint)
    end
end

return M
