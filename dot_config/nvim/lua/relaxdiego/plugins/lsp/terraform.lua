local M = {}

-- Import the shared LSP utilities
local lsp_utils = require("relaxdiego.plugins.lsp")

function M.setup(ctx)
    -- Get enhanced capabilities from shared utilities
    local capabilities = lsp_utils.get_capabilities()

    -- Create a Terraform-specific on_attach function that extends the common one
    local on_attach = lsp_utils.create_on_attach(function(client, bufnr)
        -- Terraform-specific keybindings
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Terraform validation
        vim.keymap.set("n", "<leader>tv", function()
            -- Save the file first
            vim.cmd("write")

            -- Create a new split for the output
            vim.cmd("below new")
            local output_buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_name(output_buf, "Terraform Validate Output")

            -- Run terraform validate
            local dir = vim.fn.expand("%:p:h")
            local cmd = "cd " .. vim.fn.shellescape(dir) .. " && terraform validate"

            -- Execute command and capture output
            local output = vim.fn.systemlist(cmd)

            -- Show output in the buffer
            vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, output)
            vim.api.nvim_buf_set_option(output_buf, "buftype", "nofile")
            vim.api.nvim_buf_set_option(output_buf, "modifiable", false)
        end, opts)

        -- Terraform plan
        vim.keymap.set("n", "<leader>tp", function()
            -- Save the file first
            vim.cmd("write")

            -- Create a new split for the output
            vim.cmd("below new")
            local output_buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_name(output_buf, "Terraform Plan Output")

            -- Set the buffer as a terminal
            vim.fn.termopen("cd " .. vim.fn.expand("%:p:h") .. " && terraform plan")
        end, opts)

        -- Terraform apply
        vim.keymap.set("n", "<leader>ta", function()
            -- Confirm before applying
            local choice = vim.fn.confirm("Run terraform apply?", "&Yes\n&No", 2)
            if choice == 1 then
                -- Create a new split for the output
                vim.cmd("below new")
                local output_buf = vim.api.nvim_get_current_buf()
                vim.api.nvim_buf_set_name(output_buf, "Terraform Apply Output")

                -- Set the buffer as a terminal
                vim.fn.termopen("cd " .. vim.fn.expand("%:p:h") .. " && terraform apply")
            end
        end, opts)

        -- Toggle documentation for resource under cursor
        vim.keymap.set("n", "<leader>td", function()
            local word = vim.fn.expand("<cword>")
            if word:match("^aws_") or word:match("^google_") or word:match("^azurerm_") then
                -- Open browser with Terraform documentation
                local provider = word:match("^([^_]+)_")
                local resource = word:match("^[^_]+_(.*)")
                local url

                if provider == "aws" then
                    url = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/" .. resource
                elseif provider == "google" then
                    url = "https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/" .. resource
                elseif provider == "azurerm" then
                    url = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/" .. resource
                end

                if url then
                    vim.fn.system({ "xdg-open", url })
                end
            end
        end, opts)
    end)

    -- Setup terraformls for Terraform
    require("lspconfig").terraformls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "terraform", "terraform-vars", "tf" },
    })

    -- Setup tflint for Terraform linting
    if lsp_utils.is_executable("tflint") then
        require("lspconfig").tflint.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end

    -- Format on save for Terraform files
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.tf", "*.tfvars" },
        callback = function()
            vim.lsp.buf.format({
                -- Limit client to terraformls to avoid cycling to tflint
                filter = function(client)
                    return client.name == "terraformls"
                end,
                -- Prevent the timeout errors when saving. This client is slower.
                timeout_ms = 5000,
            })
        end,
    })

    -- Set proper indentation for Terraform files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "terraform", "terraform-vars", "tf" },
        callback = function()
            -- Set Terraform-specific options
            vim.opt_local.tabstop = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.expandtab = true
            vim.opt_local.smartindent = false -- Terraform indentation can be inconsistent with smartindent
        end,
    })

    -- Add Terraform snippet command
    vim.api.nvim_create_user_command("TFResource", function()
        local resources = {
            'resource "aws_" "" {',
            "  # Resource configuration here",
            "}",
            "",
        }
        vim.api.nvim_put(vim.split(table.concat(resources, "\n"), "\n"), "l", true, true)

        -- Position cursor at the resource type
        local current_pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { current_pos[1] - 3, 10 })
    end, { desc = "Insert Terraform resource template" })
end

return M
