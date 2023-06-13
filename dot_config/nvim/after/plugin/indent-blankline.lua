-- Adds indentation guides to all lines (including empty lines).
vim.cmd [[highlight IndentBlanklineIndent guifg=#333333 gui=nocombine]]

require("indent_blankline").setup({
  -- Highlight the current indentation
  show_current_context = true,
  show_current_context_start = false,
  char_highlight_list = {
    "IndentBlanklineIndent",
  }
})
