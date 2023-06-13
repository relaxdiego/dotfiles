-- See: https://github.com/lukas-reineke/indent-blankline.nvim
-- Adds indentation guides to all lines (including empty lines).
vim.cmd [[highlight IndentBlanklineIndent guifg=#2f2f2f gui=nocombine]]

require("indent_blankline").setup({
  -- Highlight the current indentation
  show_current_context = true,
  show_current_context_start = false,
  char_highlight_list = {
    "IndentBlanklineIndent",
  },
})
