require("kanagawa").setup({
  -- Run :KanagawaCompile everytime this file is changed
  compile = true,    -- enable compiling the colorscheme
  undercurl = false, -- disable undercurls
  commentStyle = { italic = false },
  functionStyle = {},
  keywordStyle = { italic = false, bold = false },
  statementStyle = { bold = false, italic = false },
  typeStyle = {},
  transparent = false,   -- do not set background color
  dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
  terminalColors = true, -- define vim.g.terminal_color_{0,17}
  colors = {
    -- add/modify theme and palette colors
    palette = {},
    theme = {
      wave = {},
      lotus = {},
      dragon = {
        ui = {
          bg = "#1D1C19",
          nontext = "#393836",
        },
      },
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
  overrides = function(colors) -- add/modify highlights
    local theme = colors.theme
    return {
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },

      -- Save an hlgroup with dark background and dimmed foreground
      -- so that you can use it where your still want darker windows.
      -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

      -- Popular plugins that open floats will link to NormalFloat by default;
      -- set their background accordingly if you wish to keep them dark and borderless
      LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    }
  end,
  theme = "wave", -- Load "wave" theme when "background" option is not set
  background = {
    -- map the value of "background" option to a theme
    dark = "wave", -- try "dragon" !
    light = "lotus",
  },
})

vim.cmd("colorscheme kanagawa-dragon")
vim.cmd("set cursorline")
