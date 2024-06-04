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

--
-- Find more plugin-specifc remaps in the plugins/ dir
--
