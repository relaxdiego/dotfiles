# How this repo controls colors

Notes for a future agent (or human) so you don't have to re-derive the color
setup from scratch. This covers the terminal diff/UI colors: git-delta,
lazygit, Neovim, tmux, and the terminal emulator palette.

## Read this first: the layer model

Terminal colors come in three kinds, and most "why does this look different?"
puzzles come from mixing them up:

1. **24-bit truecolor** — an exact RGB value (`38;2;r;g;b`). Renders the same
   everywhere, *if* truecolor is enabled end to end (see below). Palette
   settings do not affect it.
2. **256-color indices 16–255** — the fixed color cube and grayscale ramp.
   The terminal emulator supplies these; presets and colorschemes normally
   leave them alone.
3. **The 16 base ANSI colors (indices 0–15)** — black, red, green, …, and
   their bright variants. **These get remapped by whatever layer is drawing
   the screen**, and that is the root of most surprises.

The key consequence of #3: a program that emits the 16 named ANSI colors looks
different depending on *who renders it*:

- In a **plain shell**, the 16 colors come from the **terminal emulator's**
  palette.
- Inside **Neovim's built-in `:terminal`**, they come from the Neovim
  colorscheme's `g:terminal_color_0..15`.

So the *same binary* (for example lazygit, launched at the shell vs. via
`<leader>g` inside Neovim) can show different colors, even though its config is
identical. Neovim's `:terminal` also forces `COLORTERM=truecolor`, so it always
renders 24-bit themes exactly.

## Truecolor must be enabled end to end

For any 24-bit theme (git-delta especially) to render exactly instead of being
downsampled to 256 colors, all three of these must hold:

- The shell exports `COLORTERM=truecolor` (a file under `dot_bashrc.d/`).
- tmux passes 24-bit through (`terminal-features ",*:RGB"` in `dot_tmux.conf`).
- The outer terminal emulator actually supports truecolor.

If any link is missing, delta (and similar tools) fall back to a 256-color
approximation and the theme looks "off." This is subtle because the
approximation is close but not exact.

## git-delta (diff coloring)

Configured in the `[delta …]` sections of the git config template
(`dot_gitconfig.tmpl`).

- The theme is deliberately written in **explicit hex (truecolor)** so diffs
  look identical in every context. Named ANSI colors (`yellow`, `white`) were
  replaced with kanagawa-dragon hex values so they no longer follow each
  terminal's own palette.
- `hyperlinks = true` makes commit hashes and line numbers clickable (OSC 8):
  - **Commit hashes** link to GitHub automatically when origin is GitHub.
  - **File/line links** can only point at the **local file** — delta's
    `hyperlinks-file-link-format` exposes only `{path}`, `{line}`, `{host}`,
    with no remote/commit placeholder, so a GitHub blob URL is not possible.
  - lazygit renders diffs in its own TUI, which drops OSC 8 sequences, so the
    links appear only in the **plain shell** (`git diff`/`show`/`log`), never
    in lazygit.
- Moved-code highlighting relies on `diff.colorMoved = zebra` plus the
  `[delta "highlight-moved-code"]` `map-styles`.

## lazygit UI

Config lives in `dot_config/lazygit/config.yml`. It uses delta as its diff
pager, and a `gui.theme` block pins the themeable UI to kanagawa-dragon hex.

- **Matches Neovim:** borders, selected-line highlight, options text,
  cherry-picked/marked-commit colors, unstaged-changes color, default fg.
- **Does NOT match (not themeable in lazygit):** the commit graph, commit
  hashes, dates, and branch-status colors. lazygit draws these with the 16
  ANSI colors, so in the shell they follow the **terminal emulator's** palette.
  They only match Neovim if the terminal emulator's palette *is*
  kanagawa-dragon (see next section).

## Neovim

- The active colorscheme is **kanagawa-dragon**, selected in the Neovim options
  and configured in the kanagawa plugin spec. It uses `termguicolors`
  (truecolor), so it is palette-independent — changing the terminal palette
  does not affect how Neovim itself looks.
- The kanagawa config sets `terminalColors = true`, which defines
  `g:terminal_color_0..15`. That is what recolors any program run inside
  Neovim's `:terminal` (including lazygit).

## Terminal emulator palette (the global layer)

To make the *non-themeable* shell colors (lazygit's graph/hashes/branches,
plus `ls`, `grep`, git's default output, …) match the editor, the terminal
emulator's own 16 ANSI palette must equal kanagawa-dragon. This is the only
lever for those colors; nothing in this repo's config can reach them.

A preset for **iTerm2** ships at `dot_config/iterm2/kanagawa-dragon.itermcolors`
(macOS-only; gated out of chezmoi for other OSes in `.chezmoiignore`). It is
imported manually in iTerm2 (Settings → Profiles → Colors → Color Presets →
Import). It sets the 16 ANSI colors plus foreground, background, cursor, and
selection. It does **not** touch 256-indices, so tmux's `colourNNN`-based
status bar is unaffected (only its `white`/`red` shift).

> **Do not assume iTerm2.** The user may be on a different terminal emulator in
> any given session — **ask which one they are using** before suggesting or
> generating a palette. kitty, WezTerm, Ghostty, Alacritty, etc. each configure
> their palette differently (kitty `color0..15`/`url_color`, WezTerm Lua,
> Ghostty config, Alacritty TOML). Generate an equivalent preset for their
> terminal from the palette values below.

## The kanagawa-dragon palette (source of truth = the active Neovim theme)

Values below are current as of 2026-07-09. They are derived from the running
Neovim colorscheme, so **re-extract them if the Neovim theme changes** rather
than trusting these numbers:

```sh
nvim --headless \
  -c 'lua local n=vim.api.nvim_get_hl(0,{name="Normal"}); print(string.format("fg=#%06x bg=#%06x", n.fg or 0, n.bg or 0))' \
  -c 'lua local v=vim.api.nvim_get_hl(0,{name="Visual"}); print(string.format("selection=#%06x", v.bg or 0))' \
  -c 'lua for i=0,15 do io.write(vim.g["terminal_color_"..i].." ") end print("")' \
  -c 'qa!'
```

- Foreground `#c5c9c5`, Background `#1d1c19`
- Selection (Visual bg) `#223249`, Cursor `#c5c9c5` on `#1d1c19`
- 16 ANSI colors:

| # | Role | Hex | | # | Role | Hex |
|---|------|-----|---|---|------|-----|
| 0 | black   | `#0d0c0c` | | 8  | br black   | `#a6a69c` |
| 1 | red     | `#c4746e` | | 9  | br red     | `#E46876` |
| 2 | green   | `#8a9a7b` | | 10 | br green   | `#87a987` |
| 3 | yellow  | `#c4b28a` | | 11 | br yellow  | `#E6C384` |
| 4 | blue    | `#8ba4b0` | | 12 | br blue    | `#7FB4CA` |
| 5 | magenta | `#a292a3` | | 13 | br magenta | `#938AA9` |
| 6 | cyan    | `#8ea4a2` | | 14 | br cyan    | `#7AA89F` |
| 7 | white   | `#C8C093` | | 15 | br white   | `#c5c9c5` |

## Quick debugging guide

- "Looks different in the shell vs. Neovim" → it is using the 16 ANSI colors;
  the shell uses the terminal palette, Neovim uses `g:terminal_color_*`.
- "Theme looks washed out / not exact" → truecolor is not enabled end to end;
  the 24-bit theme is being downsampled to 256 colors.
- "Only some of lazygit matches" → expected; the graph/hash/branch colors are
  not themeable and need the terminal-emulator palette to match.
