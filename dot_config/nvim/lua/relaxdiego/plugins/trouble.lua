return {
  "folke/trouble.nvim",
  commit = "2af0dd9767526410c88c628f1cbfcb6cf22dd683",
  config = function()
    -- See: https://github.com/folke/trouble.nvim
    -- List all linting errors
    vim.keymap.set("n", "<leader>xx", vim.cmd.TroubleToggle)
    require("trouble").setup({
      icons = false,
    })
  end,
}
