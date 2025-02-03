return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
        file_types = { "markdown", "Parrot" },
        heading = {
            position = "inline",
        },
        code = {
            language_name = false,
        },
    },
}
