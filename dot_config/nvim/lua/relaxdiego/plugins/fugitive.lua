return {
  "tpope/vim-fugitive",
  commit = "5f0d280b517cacb16f59316659966c7ca5e2bea2",
  config = function()
    _G.blame_toggle = function()
      local found = false
      local windows = vim.api.nvim_list_wins()
      for _, win_id in ipairs(windows) do
        if vim.api.nvim_win_is_valid(win_id) and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), 'filetype') == 'fugitiveblame' then
          vim.api.nvim_win_close(win_id, false)
          found = true
        end
      end
      if not found then
        vim.api.nvim_command('Git blame')
      end
    end

    vim.api.nvim_set_keymap('n', '<Leader>b', '<cmd>lua blame_toggle()<CR>', { desc = "Toggle Git blame" })
  end
}
