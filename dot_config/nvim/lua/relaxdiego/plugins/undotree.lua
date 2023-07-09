return {
  "mbbill/undotree",
  commit = "485f01efde4e22cb1ce547b9e8c9238f36566f21",
  config = function()
    -- See: https://github.com/mbbill/undotree
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
  end,
}
