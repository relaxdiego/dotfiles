vim.g.mapleader = ","

-- Toggle soft wrap
vim.keymap.set("n", "<leader>sw", ":set wrap!<CR>", { desc = "Toggle soft wrap" })

-- Easier split movement
vim.keymap.set("n", "<C-J>", "<C-W><C-J>", { desc = "Move up" })
vim.keymap.set("n", "<C-K>", "<C-W><C-K>", { desc = "Move down" })
vim.keymap.set("n", "<C-L>", "<C-W><C-L>", { desc = "Move right" })
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", { desc = "Move left" })

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
	{ desc = "Live search and replace" }
)

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

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
