-- For group descriptions, see whick-key plugin

vim.g.mapleader = ","

-- Toggle soft wrap
vim.keymap.set("n", "<leader>sw", ":set wrap!<CR>", { desc = "Toggle soft wrap" })

-- Keep cursor in the middle when jumping through search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match" })

-- Don't lose what's in the register after pasting
vim.keymap.set("x", "p", "pgvy", { desc = "Paste from register" })

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })

-- Search and replace live
vim.keymap.set(
    "n",
    "<leader>r",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Search and replace word under cursor" }
)

-- Equalize widths only
vim.keymap.set("n", "<C-w>=", ":horizontal wincmd =<CR>", { desc = "Equalize widths only" })

-- Recursively unfold the block where the cursor is, fold everything else
--   zM - fold everything
--   zv - unfold just enough so that the line under the cursor is visible
--   zc - fold block where the cursor is (we need this so that zO has an effect)
--   zO - recursively unfold the block where the cursor is
--   z. - Redraw curosor line to center of window, cursor on first non-blank
-- See: :help z
vim.keymap.set("n", "zz", "<Esc>zMzvzczOz.", { desc = "Fold everything except current block" })

vim.keymap.set({ "n", "v", "x" }, "gap", function()
    vim.api.nvim_feedkeys(":Prt", 'n', false)
    vim.defer_fn(function()
        require('cmp').complete()
    end, 10) -- 10ms delay to allow nvim to indicate that it's in command mode
end, { desc = "Run a Parrot command", silent = true })
vim.keymap.set({ "n", "v", "x" }, "gac", ":PrtChat<CR>", { desc = "Chat with AI", silent = true })
vim.keymap.set({ "v", "x" }, "gas", ":PrtChatPaste<CR>", { desc = "Send selection to chat", silent = true })
vim.keymap.set({ "n", "v", "x" }, "gar", ":PrtRewrite<CR>", { desc = "Rewrite inline", silent = true })
vim.keymap.set({ "n", "v", "x" }, "gai", ":PrtImplement<CR>", { desc = "Implement inline", silent = true })
vim.keymap.set({ "n", "v", "x" }, "gax", ":PrtCompleteFullContext<CR>",
    { desc = "Complete with full file context", silent = true })

--
-- Find more plugin-specifc remaps in the plugins/ dir
--
